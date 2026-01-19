import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/encryption_service.dart';
import '../services/auth_service.dart';
import '../models/password_model.dart';
import '../../core/exceptions.dart';

/// Firestore veritabanı işlemlerini yöneten repository sınıfı.
class PasswordRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Mevcut kullanıcı ID'sini döndürür.
  String? get _uid => _auth.currentUser?.uid;

  /// Kullanıcının şifrelerini gerçek zamanlı olarak (Stream) getirir.
  Stream<List<PasswordModel>> getPasswordsStream() {
    final uid = _uid;
    if (uid == null) return Stream.value([]); 

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('passwords')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PasswordModel.fromSnapshot(doc))
            .toList());
  }

  /// Yeni bir şifre ekler.
  /// 
  /// Şifre metni veritabanına kaydedilmeden önce [EncryptionService] kullanılarak şifrelenir.
  Future<void> addPassword(String title, String rawPassword) async {
    final uid = _uid;
    if (uid == null) throw Exception("Kullanıcı oturumu açık değil");
    
    final sessionKey = AuthService.sessionKey;
    if (sessionKey == null) throw Exception("Oturum süresi doldu. Lütfen tekrar giriş yapın.");

    // Asenkron Şifreleme (Isolate)
    String encryptedText = await EncryptionService.encryptAsync(rawPassword, sessionKey);

    await _firestore.collection('users').doc(uid).collection('passwords').add({
      'title': title,
      'password': encryptedText,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Belirtilen ID'ye sahip şifreyi siler.
  Future<void> deletePassword(String id) async {
    final uid = _uid;
    if (uid == null) throw Exception("Kullanıcı oturumu açık değil");

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('passwords')
        .doc(id)
        .delete();
  }

  /// Şifrelenmiş metni çözer.
  Future<String> decryptPassword(String encrypted) async {
    final sessionKey = AuthService.sessionKey;
    if (sessionKey == null) throw DecryptionException("Oturum süresi doldu");
    
    // Asenkron Şifre Çözme (Isolate)
    return await EncryptionService.decryptAsync(encrypted, sessionKey);
  }
}
