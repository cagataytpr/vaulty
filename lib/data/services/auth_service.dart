import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'secure_storage_service.dart';
import 'encryption_service.dart';

class AuthService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final LocalAuthentication _localAuth = LocalAuthentication();
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final SecureStorageService _secureStorage = SecureStorageService();
  
  /// Anahtar türetme işlemi için kullanılan sabit uygulama tuzu (salt).
  static final Uint8List _appSalt = Uint8List.fromList(utf8.encode('Vaulty_Static_Salt_v1'));

  // --- Oturum Yönetimi ---
  /// Bellekte tutulan türetilmiş anahtar (AES işlemlerine hazır).
  static Uint8List? _sessionKey;

  static Uint8List? get sessionKey => _sessionKey;

  /// Oturum anahtarını manuel olarak ayarlar.
  static void setSessionKey(Uint8List key) {
    _sessionKey = key;
  }

  /// Aktif oturum anahtarını bellekten güvenli bir şekilde siler.
  /// Bellek alanını sıfırlayarak (zero-fill) güvenliği artırır.
  static void clearSession() {
    if (_sessionKey != null) {
      for (int i = 0; i < _sessionKey!.length; i++) {
        _sessionKey![i] = 0;
      }
    }
    _sessionKey = null;
  }

  /// Kullanıcının e-posta ve şifre ile Firebase üzerinden giriş yapmasını sağlar.
  static Future<UserCredential> loginWithEmail(String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  /// Master şifre ile giriş yapar ve şifreleme anahtarını türetir.
  /// 
  /// Bu işlem sonucunda [_sessionKey] hesaplanır ve [SecureStorageService] üzerine kaydedilir.
  /// Bu kayıt işlemi, daha sonraki biyometrik girişler için kritiktir.
  static Future<void> loginWithPassword(String password) async {
    // 1. Anahtarı arka planda türet
    _sessionKey = await compute(_deriveKeyTask, {
      'password': password,
      'salt': _appSalt,
    });

    // 2. Anahtarı güvenli depolama alanına kaydet
    if (_sessionKey != null) {
      try {
        await _secureStorage.storeMasterKey(base64.encode(_sessionKey!));
      } catch (e) {
        log("Anahtar kaydedilemedi: $e");
      }
    }
  }

  /// Biyometrik doğrulama ile giriş yapar ve saklanan anahtarı çözer.
  /// 
  /// Başarılı olursa [true] döner ve [_sessionKey] set edilir.
  static Future<bool> loginWithBiometrics() async {
    try {
      if (!await authenticate(localizedReason: 'Giriş yapmak için kimliğinizi doğrulayın')) {
        return false;
      }

      String? encodedKey = await _secureStorage.getMasterKey();

      if (encodedKey != null) {
        // Saklanan anahtar derive edilmiş haldedir (base64)
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

  /// Mevcut oturum anahtarını kullanarak biyometrik girişi aktifleştirir.
  static Future<bool> enableBiometrics() async {
    if (sessionKey == null) return false;

    try {
      if (!await authenticate(localizedReason: 'Biyometrik girişi aktifleştirmek için doğrulama yapın')) {
        return false;
      }
      
      // Türetilmiş anahtarı base64 string olarak sakla
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

  /// Biyometrik penceresi açıkken uygulamanın kilitlenmesini önleyen bayrak.
  static bool isAuthenticating = false;

  /// Cihazın biyometrik donanımını kullanarak kullanıcıyı doğrular.
  /// 
  /// [localizedReason] parametresi ile kullanıcıya gösterilecek mesaj belirlenir.
  static Future<bool> authenticate({String? localizedReason}) async {
    // 1. Çift tıklamayı ve üst üste çağırmayı önle
    if (isAuthenticating) return false;

    try {
      // 2. Bayrağı kaldır: Kilit ekranı devreye girmemeli
      isAuthenticating = true;

      // Donanım desteğini kontrol et
      final bool canCheck = await _localAuth.canCheckBiometrics;
      final bool isSupported = await _localAuth.isDeviceSupported();

      if (!canCheck && !isSupported) return false;

      // 3. Önceki işlemi durdur
      await _localAuth.stopAuthentication();

      // 4. Doğrulama işlemini başlat
      return await _localAuth.authenticate(
        localizedReason: localizedReason ?? 'Şifrelerinize erişmek için lütfen kimliğinizi doğrulayın',
        options: const AuthenticationOptions(
          stickyAuth: false, // Bayat oturumları önle
          biometricOnly: false,
          useErrorDialogs: true, // Native hata pencerelerini göster
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
      // 5. Bayrağı indir: İşlem bitti, durum sıfırlandı
      isAuthenticating = false;
    }
  }

  static Future<void> stopAuthentication() async {
    await _localAuth.stopAuthentication();
  }

  /// Kullanıcıyı doğrulamak için yardımcı metot.
  static Future<bool> authenticateUser({String? localizedReason}) async {
    return await authenticate(localizedReason: localizedReason);
  }

  /// Kullanıcıya e-posta doğrulama linki gönderir.
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

  /// Kullanıcının e-posta adresini doğrulayıp doğrulamadığını kontrol eder.
  static Future<bool> isEmailVerified() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.reload();
      return _firebaseAuth.currentUser!.emailVerified;
    }
    return false;
  }

  /// Oturumu kapatır ve bellekten hassas verileri temizler.
  static Future<void> signOut() async {
    clearSession();
    await _firebaseAuth.signOut();
  }
}

// Anahtar türetme işlemi için arka planda (Isolate) çalışacak görev fonksiyonu
Uint8List _deriveKeyTask(Map<String, dynamic> params) {
  return EncryptionService.deriveKey(params['password'] as String, params['salt'] as Uint8List);
}
