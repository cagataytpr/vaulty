import 'package:encrypt/encrypt.dart' as encrypt_pkg;
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class EncryptionService {

  static encrypt_pkg.Key _deriveKey(String userUid, String masterKey) {
    var bytes = utf8.encode(masterKey + userUid);
    var digest = sha256.convert(bytes);
    return encrypt_pkg.Key(Uint8List.fromList(digest.bytes));
  }

  // Legacy IV derivation (for backward compatibility)
  static encrypt_pkg.IV _deriveLegacyIV(String userUid) {
    var bytes = utf8.encode("$userUid" "Vaulty_IV_Salt");
    var digest = sha256.convert(bytes);
    return encrypt_pkg.IV(Uint8List.fromList(digest.bytes.sublist(0, 16)));
  }

  static String encrypt(String password, String userUid, String masterKey) {
    try {
      final key = _deriveKey(userUid, masterKey);
      
      // 1. Generate Random IV (16 bytes)
      final iv = encrypt_pkg.IV.fromLength(16);
      
      final encrypter = encrypt_pkg.Encrypter(encrypt_pkg.AES(key));
      final encrypted = encrypter.encrypt(password, iv: iv);
      
      // 2. Return format: IV:EncryptedData
      return "${iv.base64}:${encrypted.base64}";
    } catch (e) {
      throw Exception("Encryption failed: $e");
    }
  }

  static String decrypt(String encryptedData, String userUid, String masterKey) {
    try {
      final key = _deriveKey(userUid, masterKey);
      final encrypter = encrypt_pkg.Encrypter(encrypt_pkg.AES(key));

      // 3. Check format
      if (encryptedData.contains(':')) {
        // New Format: IV:Cipher
        final parts = encryptedData.split(':');
        if (parts.length != 2) throw Exception("Invalid encrypted data format");
        
        final iv = encrypt_pkg.IV.fromBase64(parts[0]);
        final cipherText = parts[1];
        
        return encrypter.decrypt64(cipherText, iv: iv);
      } else {
        // Legacy Format: Static IV
        // Fallback for existing passwords
        final iv = _deriveLegacyIV(userUid);
        return encrypter.decrypt64(encryptedData, iv: iv);
      }
    } catch (e) {
      // log("Decryption Error: $e"); 
      // Return a clean error or rethrow depending on app policy. 
      // For now returning generic error text that UI might handle or display.
      return "Error: Decryption failed"; 
    }
  }
}