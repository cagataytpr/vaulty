import 'dart:async';
import 'package:flutter/material.dart'; // For Context
import 'package:flutter/foundation.dart'; // For compute
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/services/encryption_service.dart';
import '../data/models/password_model.dart';
import '../data/repositories/password_repository.dart';
import '../data/services/auth_service.dart';
import 'package:vaulty/l10n/app_localizations.dart';

import 'dart:typed_data'; // For Uint8List

// Class to pass data to the isolate
class AuditParams {
  final List<PasswordModel> passwords;
  final String uid;
  final Uint8List masterKey;

  AuditParams({
    required this.passwords,
    required this.uid,
    required this.masterKey,
  });
}

// Output DTO for the isolate
class RiskItem {
  final String title;
  final String type; // 'WEAK' or 'REUSED'

  RiskItem(this.title, this.type);
}

// Top-level function for the isolate
Future<List<RiskItem>> auditPasswords(AuditParams params) async {
  List<RiskItem> risks = [];
  Map<String, int> counts = {};

  // 1. First Pass: Decrypt and Count
  for (var pass in params.passwords) {
    try {
      // Use SYNC decrypt as we are already in an isolate
      final decrypted = EncryptionService.decrypt(
          pass.encryptedPassword, params.masterKey);
      
      counts[decrypted] = (counts[decrypted] ?? 0) + 1;
      
      if (decrypted.length < 8) {
        risks.add(RiskItem(pass.title, 'WEAK'));
      }
    } catch (e) {
      continue;
    }
  }

  // 2. Second Pass: Check Reused
  for (var pass in params.passwords) {
    try {
       final decrypted = EncryptionService.decrypt(
          pass.encryptedPassword, params.masterKey);
       
       // Avoid duplicates if already flagged as weak? 
       // Requirement implies listing both if applicable, or just listing risks.
       // Logic in UI was: list Weak, then list Reused.
       // We'll mimic that.
       
       if ((counts[decrypted] ?? 0) > 1) {
         risks.add(RiskItem(pass.title, 'REUSED'));
       }
    } catch (e) {
      continue;
    }
  }

  return risks;
}

class HomeViewModel extends ChangeNotifier {
  final PasswordRepository _repository = PasswordRepository();
  
  List<PasswordModel> _allPasswords = [];
  List<PasswordModel> _filteredPasswords = [];
  List<RiskItem> _preCalculatedRisks = []; // Cached results

  StreamSubscription<List<PasswordModel>>? _subscription;
  StreamSubscription<User?>? _authSubscription;
  bool _isLoading = true; 

  String _searchQuery = "";
  int _riskCount = 0;

  List<PasswordModel> get passwords => _filteredPasswords;
  List<PasswordModel> get allPasswordsRaw => _allPasswords;
  int get riskCount => _riskCount;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  HomeViewModel() {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      _subscription?.cancel(); 
      if (user != null) {
        _isLoading = true;
        notifyListeners();
        _subscribeToPasswords();
      } else {
        _allPasswords = [];
        _filteredPasswords = [];
        _preCalculatedRisks = [];
        _riskCount = 0;
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  void _subscribeToPasswords() {
    _subscription = _repository.getPasswordsStream().listen((passwords) {
      _allPasswords = passwords;
      _performAudit();
      _filterPasswords();
      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      _allPasswords = [];
      _filteredPasswords = [];
      _riskCount = 0;
      _isLoading = false;
      notifyListeners();
    });
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _filterPasswords();
    notifyListeners();
  }

  void _filterPasswords() {
    if (_searchQuery.isEmpty) {
      _filteredPasswords = List.from(_allPasswords);
    } else {
      _filteredPasswords = _allPasswords
          .where((p) => p.title.toLowerCase().contains(_searchQuery))
          .toList();
    }
  }

  Future<void> _performAudit() async {
    final user = FirebaseAuth.instance.currentUser;
    final sessionKey = AuthService.sessionKey;
    
    if (user == null || _allPasswords.isEmpty || sessionKey == null) {
        _riskCount = 0;
        _preCalculatedRisks = [];
        notifyListeners();
        return;
    }

    final params = AuditParams(
      passwords: List.from(_allPasswords), 
      uid: user.uid,
      masterKey: sessionKey, 
    );

    try {
      _preCalculatedRisks = await compute(auditPasswords, params);
      _riskCount = _preCalculatedRisks.length;
    } catch (e) {
      _riskCount = 0;
      _preCalculatedRisks = [];
    }
    notifyListeners();
  }

  Future<void> addNewPassword(String title, String rawPassword) async {
    await _repository.addPassword(title, rawPassword);
  }

  Future<void> deletePassword(String id) async {
    await _repository.deletePassword(id);
  }

  Future<String> decryptPassword(String encrypted) async {
    return await _repository.decryptPassword(encrypted);
  }

  // Returns cache, very fast
  List<Map<String, String>> getSecurityReport(BuildContext context) {
    if (_preCalculatedRisks.isEmpty) return [];

    final l10n = AppLocalizations.of(context)!;
    
    return _preCalculatedRisks.map((item) {
      String reason = item.type == 'WEAK' ? l10n.riskWeak : l10n.riskReused;
      return {
        "title": item.title,
        "reason": reason,
      };
    }).toList();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _authSubscription?.cancel();
    super.dispose();
  }
}
