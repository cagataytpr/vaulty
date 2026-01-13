import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'secure_storage_service.dart';

class AuthService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final LocalAuthentication _localAuth = LocalAuthentication();
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final SecureStorageService _secureStorage = SecureStorageService();

  // --- Session Management ---
  // In-memory decrypted Master Key
  static String? _sessionKey;

  static String? get sessionKey => _sessionKey;

  static void setSessionKey(String key) {
    _sessionKey = key;
  }

  static void clearSession() {
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
    // For now, we trust the password provided is correct if it unlocks/decrypts successfully later.
    // In a real app, we might verify a hash here or try to decrypt a test token.
    // Setting session key:
    setSessionKey(password);
  }

  // --- Login with Biometrics (retrieves session) ---
  static Future<bool> loginWithBiometrics() async {
    try {
      // 1. Check if biometrics available
      if (!await authenticate(localizedReason: 'Giriş yapmak için kimliğinizi doğrulayın')) {
        return false;
      }

      // 2. Try to get Master Key from Secure Storage
      String? masterKey = await _secureStorage.getMasterKey();

      if (masterKey != null) {
        setSessionKey(masterKey);
        return true;
      } else {
        // No key stored, fallback to password
        return false;
      }
    } catch (e) {
      log("Biometric login failed: $e");
      return false;
    }
  }

  // --- Enable Biometrics (saves current session) ---
  static Future<bool> enableBiometrics() async {
    if (_sessionKey == null) return false;

    try {
      if (!await authenticate(localizedReason: 'Biyometrik girişi aktifleştirmek için doğrulama yapın')) {
        return false;
      }
      
      await _secureStorage.storeMasterKey(_sessionKey!);
      return true;
    } catch (e) {
      log("Enable biometrics failed: $e");
      return false;
    }
  }

  static Future<void> sendPasswordReset(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }

  // --- 1. BIOMETRIC AUTHENTICATION (Low Level) ---
  static Future<bool> authenticate({String? localizedReason}) async {
    try {
      final bool canCheck = await _localAuth.canCheckBiometrics;
      final bool isSupported = await _localAuth.isDeviceSupported();

      if (!canCheck && !isSupported) return false;

      return await _localAuth.authenticate(
        localizedReason: localizedReason ?? 'Şifrelerinize erişmek için lütfen kimliğinizi doğrulayın',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } catch (e) {
      log("Biyometrik hata: $e");
      return false;
    }
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
