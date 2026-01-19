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

/// Isolate işlemine veri aktarmak için kullanılan DTO sınıfı.
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

/// Isolate sonucunda dönen risk parametresi.
class RiskItem {
  final String title;
  final String type; // 'WEAK' (Zayıf) veya 'REUSED' (Tekrar Eden)

  RiskItem(this.title, this.type);
}

/// Şifreleri analiz eden ve güvenlik risklerini belirleyen Isolate fonksiyonu.
Future<List<RiskItem>> auditPasswords(AuditParams params) async {
  List<RiskItem> risks = [];
  Map<String, int> counts = {};

  // 1. Aşama: Şifreleri Çöz ve Analiz Et
  for (var pass in params.passwords) {
    try {
      // Isolate içinde olduğumuz için senkron decrypt kullanabiliriz
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

  // 2. Aşama: Tekrar Eden Şifreleri Kontrol Et
  for (var pass in params.passwords) {
    try {
       final decrypted = EncryptionService.decrypt(
          pass.encryptedPassword, params.masterKey);
       
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

  /// Şifreleri arka planda analiz ederek güvenlik raporu oluşturur.
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

  /// Hesaplanmış güvenlik risklerini döndürür.
  /// Sonuç önbellekten geldiği için hızlı çalışır.
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
