import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:developer';
import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'secure_storage_service.dart';
import 'encryption_service.dart';

class AuthService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final LocalAuthentication _localAuth = LocalAuthentication();
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final SecureStorageService _secureStorage = SecureStorageService();
  
  // --- Oturum Yönetimi ---
  /// Oturum anahtarı artık EncryptionService üzerinden yönetilir.
  static Uint8List? get sessionKey => EncryptionService.currentKey;

  /// Oturum anahtarını manuel olarak ayarlar.
  static void setSessionKey(Uint8List key) {
    EncryptionService.setKey(key);
  }

  /// Aktif oturum anahtarını bellekten güvenli bir şekilde siler.
  /// Bellek alanını sıfırlayarak (zero-fill) güvenliği artırır.
  static void clearSession() {
    EncryptionService.clearKey();
  }

  /// Kullanıcının e-posta ve şifre ile Firebase üzerinden giriş yapmasını sağlar.
  static Future<UserCredential> loginWithEmail(String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  /// Master şifre ile giriş yapar ve SHA-256 ile şifreleme anahtarını türetir.
  /// 
  /// Bu işlem sonucunda anahtar [EncryptionService] üzerine yüklenir
  /// ve [SecureStorageService] üzerine kaydedilir (biyometrik giriş için).
  static Future<void> loginWithPassword(String password) async {
    // 1. SHA-256 ile deterministik anahtar türet
    EncryptionService.setKeyFromPassword(password);

    // 2. Anahtarı güvenli depolama alanına kaydet (biyometrik giriş için)
    final key = EncryptionService.currentKey;
    if (key != null) {
      try {
        await _secureStorage.storeMasterKey(base64.encode(key));
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
        // Saklanan anahtar SHA-256 ile türetilmiş haldedir (base64)
        EncryptionService.setKey(Uint8List.fromList(base64.decode(encodedKey)));
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

  /// Yeni kullanıcı kaydı oluşturur, doğrulama e-postası gönderir ve oturumu kapatır.
  ///
  /// Kayıt sonrası oturumu hemen kapatarak kullanıcının e-posta doğrulaması
  /// yapılmadan Ana Sayfaya yönlendirilmesini önler.
  static Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    // Doğrulama e-postasını gönder
    await userCredential.user?.sendEmailVerification();

    // KRİTİK: Oturumu hemen kapat — kullanıcı doğrulama yapmadan giriş yapamamalı
    await _firebaseAuth.signOut();

    return userCredential;
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

