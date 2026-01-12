import 'package:encrypt/encrypt.dart' as encrypt_pkg;
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class EncryptionService {
  static const String _masterKey = "Vaulty_Master_Secret_2024_!@#";

  // Anahtarı türet (Zaten UID kullandığın için burası sağlam)
  static encrypt_pkg.Key _deriveKey(String userUid) {
    var bytes = utf8.encode(_masterKey + userUid);
    var digest = sha256.convert(bytes);
    return encrypt_pkg.Key(Uint8List.fromList(digest.bytes));
  }

  // BURASI DEĞİŞTİ: IV'yi rastgele değil, UID'den türetilen sabit bir değer yapıyoruz
  static encrypt_pkg.IV _deriveIV(String userUid) {
    var bytes = utf8.encode("$userUid" "Vaulty_IV_Salt");
    var digest = sha256.convert(bytes);
    // AES için 16 byte lazım, digest'ın ilk 16 byte'ını alıyoruz
    return encrypt_pkg.IV(Uint8List.fromList(digest.bytes.sublist(0, 16)));
  }

  static String encrypt(String password, String userUid) {
    final key = _deriveKey(userUid);
    final iv = _deriveIV(userUid); // Sabit IV
    final encrypter = encrypt_pkg.Encrypter(encrypt_pkg.AES(key));
    final encrypted = encrypter.encrypt(password, iv: iv);
    return encrypted.base64;
  }

  static String decrypt(String encryptedPassword, String userUid) {
    try {
      final key = _deriveKey(userUid);
      final iv = _deriveIV(userUid); // Şifrelerken kullanılan aynı sabit IV
      final encrypter = encrypt_pkg.Encrypter(encrypt_pkg.AES(key));
      final decrypted = encrypter.decrypt64(encryptedPassword, iv: iv);
      return decrypted;
    } catch (e) {
      // print("Decryption Error: $e");
      return "Hata: Şifre çözülemedi";
    }
  }
}