import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt_pkg;
import 'package:pointycastle/export.dart';
import '../../core/exceptions.dart';

class EncryptionService {
  static const int _pbkdf2Iterations = 200000;
  static const int _keyLength = 32; // 256 bits

  /// Generates a random salt of [length] bytes.
  static Uint8List _generateRandomBytes(int length) {
    final rnd = Random.secure();
    final bytes = Uint8List(length);
    for (var i = 0; i < length; i++) {
      bytes[i] = rnd.nextInt(256);
    }
    return bytes;
  }

  /// Derives a key from [password] and [salt] using PBKDF2.
  static Uint8List _deriveKey(String password, Uint8List salt) {
    final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
      ..init(Pbkdf2Parameters(salt, _pbkdf2Iterations, _keyLength));

    return pbkdf2.process(utf8.encode(password));
  }

  /// Encrypts [data] using [masterPassword].
  /// Returns format: `Salt:IV:Cipher` (all Base64 encoded).
  static String encrypt(String data, String masterPassword) {
    try {
      // 1. Generate Random Salt (16 bytes)
      final salt = _generateRandomBytes(16);

      // 2. Derive Key using PBKDF2
      final keyBytes = _deriveKey(masterPassword, salt);
      final key = encrypt_pkg.Key(keyBytes);

      // 3. Generate Random IV (16 bytes)
      final iv = encrypt_pkg.IV.fromLength(16);

      // 4. Encrypt
      final encrypter = encrypt_pkg.Encrypter(encrypt_pkg.AES(key));
      final encrypted = encrypter.encrypt(data, iv: iv);

      // 5. Return Encoded Format
      final saltBase64 = base64.encode(salt);
      return "$saltBase64:${iv.base64}:${encrypted.base64}";
    } catch (e) {
      throw Exception("Encryption failed: $e");
    }
  }

  /// Decrypts [encryptedData] using [masterPassword].
  /// Expects format: `Salt:IV:Cipher`.
  static String decrypt(String encryptedData, String masterPassword) {
    try {
      final parts = encryptedData.split(':');
      if (parts.length != 3) {
        throw DecryptionException("Invalid encrypted data format. Expected Salt:IV:Cipher.");
      }

      final salt = base64.decode(parts[0]);
      final iv = encrypt_pkg.IV.fromBase64(parts[1]);
      final cipherText = parts[2];

      // 1. Re-derive Key using extracted Salt
      final keyBytes = _deriveKey(masterPassword, salt);
      final key = encrypt_pkg.Key(keyBytes);

      // 2. Decrypt
      final encrypter = encrypt_pkg.Encrypter(encrypt_pkg.AES(key));
      return encrypter.decrypt64(cipherText, iv: iv);
    } catch (e) {
      if (e is DecryptionException) rethrow;
      throw DecryptionException("Decryption failed", e);
    }
  }
}