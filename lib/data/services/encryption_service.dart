import 'dart:convert';

import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import 'package:encrypt/encrypt.dart' as encrypt_pkg;
import 'package:pointycastle/export.dart';
import '../../core/exceptions.dart';

class EncryptionService {
  static const int _pbkdf2Iterations = 200000;
  static const int _keyLength = 32;

  /// PBKDF2 algoritması ile şifreden kriptografik anahtar türetir.
  /// 
  /// Bu işlem işlemci maliyetlidir, bu nedenle ana thread'i bloklamamak için
  /// `compute` veya arka plan servislerinde kullanılması önerilir.
  static Uint8List deriveKey(String password, Uint8List salt) {
    final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
      ..init(Pbkdf2Parameters(salt, _pbkdf2Iterations, _keyLength));

    return pbkdf2.process(utf8.encode(password));
  }

  /// Veriyi AES algoritması ile şifreler.
  /// 
  /// Format: `IV:Cipher` (Initialization Vector ve Şifreli Metin base64 formatında ayrılmış olarak döner).
  static String encrypt(String data, Uint8List keyBytes) {
    try {
      final key = encrypt_pkg.Key(keyBytes);
      final iv = encrypt_pkg.IV.fromLength(16); 
      final encrypter = encrypt_pkg.Encrypter(encrypt_pkg.AES(key));
      
      final encrypted = encrypter.encrypt(data, iv: iv);
      return "${iv.base64}:${encrypted.base64}";
    } catch (e) {
      throw Exception("Encryption failed: $e");
    }
  }

  /// Şifrelenmiş veriyi (IV:Cipher formatında) çözer.
  static String decrypt(String encryptedData, Uint8List keyBytes) {
    try {
      final parts = encryptedData.split(':');
      if (parts.length != 2) {
        throw DecryptionException("Geçersiz format. Beklenen: IV:Cipher");
      }

      final iv = encrypt_pkg.IV.fromBase64(parts[0]);
      final cipherText = parts[1];
      
      final key = encrypt_pkg.Key(keyBytes);
      final encrypter = encrypt_pkg.Encrypter(encrypt_pkg.AES(key));
      
      return encrypter.decrypt64(cipherText, iv: iv);
    } catch (e) {
      if (e is DecryptionException) rethrow;
      throw DecryptionException("Şifre çözme hatası", e);
    }
  }

  // --- ASENKRON METOTLAR ---
  
  /// Veriyi asenkron olarak şifreler.
  /// (AES tekil bloklar için yeterince hızlıdır ancak API tutarlılığı için eklenmiştir)
  static Future<String> encryptAsync(String data, Uint8List key) async {
    return encrypt(data, key);
  }

  /// Veriyi asenkron olarak çözer.
  static Future<String> decryptAsync(String encryptedData, Uint8List key) async {
    return decrypt(encryptedData, key);
  }
}