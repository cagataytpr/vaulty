import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For PlatformException
import 'package:local_auth/local_auth.dart';
import 'dart:developer';
import 'dart:convert'; // For utf8
import 'dart:typed_data'; // For Uint8List
import 'package:flutter/foundation.dart'; // For compute
import 'package:firebase_auth/firebase_auth.dart';
import 'secure_storage_service.dart';
import 'encryption_service.dart';

class AuthService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final LocalAuthentication _localAuth = LocalAuthentication();
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final SecureStorageService _secureStorage = SecureStorageService();
  
  // Constant App Salt for Derive-Once
  static final Uint8List _appSalt = Uint8List.fromList(utf8.encode('Vaulty_Static_Salt_v1'));

  // --- Session Management ---
  // In-memory Derived Key (Ready for AES)
  static Uint8List? _sessionKey;

  static Uint8List? get sessionKey => _sessionKey;

  static void setSessionKey(Uint8List key) {
    _sessionKey = key;
  }

  static void clearSession() {
    if (_sessionKey != null) {
      for (int i = 0; i < _sessionKey!.length; i++) {
        _sessionKey![i] = 0;
      }
    }
    _sessionKey = null;
  }

  // --- 0. LOGIN (GENERIC) ---
  static Future<UserCredential> loginWithEmail(String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  // --- Login with Password (sets session) ---
  static Future<void> loginWithPassword(String password) async {
    // 1. Anahtarı türet
    _sessionKey = await compute(_deriveKeyTask, {
      'password': password,
      'salt': _appSalt,
    });

    // 2. KAYDET: Anahtarı Secure Storage'a yaz.
    // Bunu yapmazsak Biyometrik giriş çalışmaz.
    if (_sessionKey != null) {
      try {
        await _secureStorage.storeMasterKey(base64.encode(_sessionKey!));
      } catch (e) {
        log("Anahtar kaydedilemedi: $e");
      }
    }
  }

  // --- Login with Biometrics (retrieves session) ---
  static Future<bool> loginWithBiometrics() async {
    try {
      if (!await authenticate(localizedReason: 'Giriş yapmak için kimliğinizi doğrulayın')) {
        return false;
      }

      String? encodedKey = await _secureStorage.getMasterKey();

      if (encodedKey != null) {
        // The stored key is expected to be the DERIVED key (base64 encoded)
        // If coming from old version, this might break, but user accepted invalidation.
        setSessionKey(base64.decode(encodedKey));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("Biometric login failed: $e");
      return false;
    }
  }

  // --- Enable Biometrics (saves current session) ---
  static Future<bool> enableBiometrics() async {
    if (sessionKey == null) return false;

    try {
      if (!await authenticate(localizedReason: 'Biyometrik girişi aktifleştirmek için doğrulama yapın')) {
        return false;
      }
      
      // Store the derived key as base64 string
      await _secureStorage.storeMasterKey(base64.encode(sessionKey!));
      return true;
    } catch (e) {
      log("Enable biometrics failed: $e");
      return false;
    }
  }

  static Future<void> sendPasswordReset(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }



  // Flag to prevent app locking during biometric dialog
  static bool isAuthenticating = false;

  // --- 1. BIOMETRIC AUTHENTICATION (Low Level) ---
  static Future<bool> authenticate({String? localizedReason}) async {
    // 1. Double-click prevention
    if (isAuthenticating) return false;

    try {
      // 2. RAISE THE FLAG: Tell main.dart "Don't lock me!"
      isAuthenticating = true;

      // Check hardware support - keeps fail-fast behavior
      final bool canCheck = await _localAuth.canCheckBiometrics;
      final bool isSupported = await _localAuth.isDeviceSupported();

      if (!canCheck && !isSupported) return false;

      // 3. Stop previous auth to be safe
      await _localAuth.stopAuthentication();

      // 4. Authenticate
      return await _localAuth.authenticate(
        localizedReason: localizedReason ?? 'Şifrelerinize erişmek için lütfen kimliğinizi doğrulayın',
        options: const AuthenticationOptions(
          stickyAuth: false, // Critical: Prevent stale sessions
          biometricOnly: false,
          useErrorDialogs: true, // Critical: Show native errors
        ),
      );
    } on PlatformException catch (e) {
      if (e.code == 'LockedOut' || e.code == 'PermanentlyLockedOut') {
        rethrow;
      }
      log("Biyometrik hata (PlatformException): ${e.message}");
      return false;
    } catch (e) {
      log("Biyometrik hata: $e");
      return false;
    } finally {
      // 5. LOWER THE FLAG: Reset state no matter what happens
      isAuthenticating = false;
    }
  }

  static Future<void> stopAuthentication() async {
    await _localAuth.stopAuthentication();
  }

  // Helper alias
  static Future<bool> authenticateUser({String? localizedReason}) async {
    return await authenticate(localizedReason: localizedReason);
  }

  // --- 2. 2FA: EMAIL VERIFICATION ---
  static Future<void> sendVerificationEmail() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        log("Doğrulama e-postası gönderildi.");
      }
    } catch (e) {
      log("E-posta gönderme hatası: $e");
    }
  }

  // --- 3. 2FA: CHECK STATUS ---
  static Future<bool> isEmailVerified() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.reload();
      return _firebaseAuth.currentUser!.emailVerified;
    }
    return false;
  }

  // --- 4. SIGN OUT ---
  static Future<void> signOut() async {
    clearSession();
    await _firebaseAuth.signOut();
  }
}

// Top-level task for key derivation
Uint8List _deriveKeyTask(Map<String, dynamic> params) {
  return EncryptionService.deriveKey(params['password'] as String, params['salt'] as Uint8List);
}
