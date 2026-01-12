import 'package:local_auth/local_auth.dart';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final LocalAuthentication _localAuth = LocalAuthentication();
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // --- 0. LOGIN (GENERIC) ---
  static Future<UserCredential> loginWithEmail(String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  static Future<void> sendPasswordReset(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }

  // --- 1. BİYOMETRİK DOĞRULAMA (Kasa Açılışında) ---
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

  // Helper alias for clarify or specific use cases requested by user
  static Future<bool> authenticateUser({String? localizedReason}) async {
    return await authenticate(localizedReason: localizedReason);
  }

  // --- 2. 2FA: E-POSTA DOĞRULAMA GÖNDERME ---
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

  // --- 3. 2FA: DOĞRULAMA DURUMUNU KONTROL ET ---
  static Future<bool> isEmailVerified() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      // Firebase'den güncel veriyi çekmek için reload şart
      await user.reload();
      return _firebaseAuth.currentUser!.emailVerified;
    }
    return false;
  }

  // --- 4. ÇIKIŞ YAPMA ---
  static Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
