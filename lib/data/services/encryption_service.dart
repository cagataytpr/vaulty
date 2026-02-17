import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt_pkg;
import '../../core/exceptions.dart';

/// Şifreleme servisi.
///
/// Master şifreden SHA-256 ile deterministik anahtar türetir.
/// Aynı şifre her cihazda aynı anahtarı üretir, böylece
/// platformlar arası (PC <-> Mobil) senkronizasyon sağlanır.
class EncryptionService {
  /// Bellekte tutulan türetilmiş şifreleme anahtarı.
  static Uint8List? _currentKey;

  /// Mevcut şifreleme anahtarını döndürür.
  static Uint8List? get currentKey => _currentKey;

  /// Master şifreden SHA-256 ile deterministik anahtar türetir ve belleğe yükler.
  ///
  /// Aynı şifre her zaman aynı 32 baytlık anahtarı üretir,
  /// bu sayede farklı cihazlarda aynı veriler çözülebilir.
  static void setKeyFromPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    _currentKey = Uint8List.fromList(hash.bytes);
  }

  /// Anahtarı manuel olarak ayarlar (örn. biyometrik giriş sonrası).
  static void setKey(Uint8List key) {
    _currentKey = key;
  }

  /// Bellekteki anahtarı güvenli şekilde siler.
  static void clearKey() {
    if (_currentKey != null) {
      for (int i = 0; i < _currentKey!.length; i++) {
        _currentKey![i] = 0;
      }
    }
    _currentKey = null;
  }

  /// Veriyi AES algoritması ile şifreler.
  ///
  /// Format: `IV:Cipher` (Initialization Vector ve Şifreli Metin base64 formatında).
  /// Anahtar ayarlanmamışsa hata fırlatır.
  static String encrypt(String data, [Uint8List? keyBytes]) {
    final effectiveKey = keyBytes ?? _currentKey;
    if (effectiveKey == null) {
      throw StateError('Şifreleme anahtarı ayarlanmadı. Önce setKeyFromPassword() çağrılmalı.');
    }

    try {
      final key = encrypt_pkg.Key(effectiveKey);
      final iv = encrypt_pkg.IV.fromLength(16);
      final encrypter = encrypt_pkg.Encrypter(encrypt_pkg.AES(key));

      final encrypted = encrypter.encrypt(data, iv: iv);
      return "${iv.base64}:${encrypted.base64}";
    } catch (e) {
      throw Exception("Encryption failed: $e");
    }
  }

  /// Şifrelenmiş veriyi (IV:Cipher formatında) çözer.
  /// Anahtar ayarlanmamışsa hata fırlatır.
  static String decrypt(String encryptedData, [Uint8List? keyBytes]) {
    final effectiveKey = keyBytes ?? _currentKey;
    if (effectiveKey == null) {
      throw StateError('Şifreleme anahtarı ayarlanmadı. Önce setKeyFromPassword() çağrılmalı.');
    }

    try {
      final parts = encryptedData.split(':');
      if (parts.length != 2) {
        throw DecryptionException("Geçersiz format. Beklenen: IV:Cipher");
      }

      final iv = encrypt_pkg.IV.fromBase64(parts[0]);
      final cipherText = parts[1];

      final key = encrypt_pkg.Key(effectiveKey);
      final encrypter = encrypt_pkg.Encrypter(encrypt_pkg.AES(key));

      return encrypter.decrypt64(cipherText, iv: iv);
    } catch (e) {
      if (e is DecryptionException) rethrow;
      throw DecryptionException("Şifre çözme hatası", e);
    }
  }

  // --- ASENKRON METOTLAR ---

  /// Veriyi asenkron olarak şifreler.
  static Future<String> encryptAsync(String data, [Uint8List? key]) async {
    return encrypt(data, key);
  }

  /// Veriyi asenkron olarak çözer.
  static Future<String> decryptAsync(String encryptedData, [Uint8List? key]) async {
    return decrypt(encryptedData, key);
  }
}