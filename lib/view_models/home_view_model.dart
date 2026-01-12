import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/models/password_model.dart';
import '../data/repositories/password_repository.dart';


class HomeViewModel extends ChangeNotifier {
  final PasswordRepository _repository = PasswordRepository();
  
  List<PasswordModel> _allPasswords = [];
  List<PasswordModel> _filteredPasswords = [];
  StreamSubscription<List<PasswordModel>>? _subscription;
  StreamSubscription<User?>? _authSubscription;
  bool _isLoading = true; // Default to true

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
      _subscription?.cancel(); // Cancel exiting password stream
      
      if (user != null) {
        // User logged in, subscribe to their data
        _isLoading = true;
        notifyListeners();
        _subscribeToPasswords();
      } else {
        // User logged out
        _allPasswords = [];
        _filteredPasswords = [];
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
      // Handle stream errors (e.g. permission denied on logout)
      _allPasswords = [];
      _filteredPasswords = [];
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

  void _performAudit() {
    int weak = 0;
    Map<String, int> counts = {};

    for (var pass in _allPasswords) {
      try {
        final decrypted = _repository.decryptPassword(pass.encryptedPassword);
        // Only count valid decryptions
        if (decrypted == "User not logged in" || decrypted.startsWith("Hata:")) {
             continue;
        }

        if (decrypted.length < 8) weak++;
        counts[decrypted] = (counts[decrypted] ?? 0) + 1;
      } catch (e) {
        continue;
      }
    }

    int reused = counts.values.where((c) => c > 1).length;
    _riskCount = weak + reused;
  }

  Future<void> addNewPassword(String title, String rawPassword) async {
    await _repository.addPassword(title, rawPassword);
  }

  Future<void> deletePassword(String id) async {
    await _repository.deletePassword(id);
    // Stream update will handle UI refresh
  }

  String decryptPassword(String encrypted) {
    return _repository.decryptPassword(encrypted);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _authSubscription?.cancel();
    super.dispose();
  }
}
