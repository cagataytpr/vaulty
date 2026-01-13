import 'dart:convert';

import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // For compute

import 'package:encrypt/encrypt.dart' as encrypt_pkg;
import 'package:pointycastle/export.dart';
import '../../core/exceptions.dart';

class EncryptionService {
  static const int _pbkdf2Iterations = 200000;
  static const int _keyLength = 32; // 256 bits

  // 1. Public Key Derivation (Heavy Operation)
  static Uint8List deriveKey(String password, Uint8List salt) {
    final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
      ..init(Pbkdf2Parameters(salt, _pbkdf2Iterations, _keyLength));

    return pbkdf2.process(utf8.encode(password));
  }

  // 2. Encrypt using Pre-Derived Key (Fast AES)
  // Format: IV:Cipher
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

  // 3. Decrypt using Pre-Derived Key (Fast AES)
  static String decrypt(String encryptedData, Uint8List keyBytes) {
    try {
      final parts = encryptedData.split(':');
      if (parts.length != 2) {
        throw DecryptionException("Invalid format. Expected IV:Cipher");
      }

      final iv = encrypt_pkg.IV.fromBase64(parts[0]);
      final cipherText = parts[1];
      
      final key = encrypt_pkg.Key(keyBytes);
      final encrypter = encrypt_pkg.Encrypter(encrypt_pkg.AES(key));
      
      return encrypter.decrypt64(cipherText, iv: iv);
    } catch (e) {
      if (e is DecryptionException) rethrow;
      throw DecryptionException("Decryption failed", e);
    }
  }

  // --- ASYNC METHODS ---
  // AES is fast enough to run on main thread for single items, 
  // avoiding Isolate serialization overhead.
  
  static Future<String> encryptAsync(String data, Uint8List key) async {
    return encrypt(data, key);
  }

  static Future<String> decryptAsync(String encryptedData, Uint8List key) async {
    return decrypt(encryptedData, key);
  }
}