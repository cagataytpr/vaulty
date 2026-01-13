import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants.dart';
import '../services/encryption_service.dart';
import '../models/password_model.dart';

class PasswordRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Helper to get current User ID
  String? get _uid => _auth.currentUser?.uid;

  Stream<List<PasswordModel>> getPasswordsStream() {
    final uid = _uid;
    if (uid == null) return Stream.value([]); // Or throw error/return empty

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

  Future<void> addPassword(String title, String rawPassword) async {
    final uid = _uid;
    if (uid == null) throw Exception("User not logged in");

    // Pass Master Key temporarily from constants
    String encryptedText = EncryptionService.encrypt(rawPassword, uid, AppConstants.MASTER_KEY);

    await _firestore.collection('users').doc(uid).collection('passwords').add({
      'title': title,
      'password': encryptedText,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deletePassword(String id) async {
    final uid = _uid;
    if (uid == null) throw Exception("User not logged in");

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('passwords')
        .doc(id)
        .delete();
  }

  String decryptPassword(String encrypted) {
    final uid = _uid;
    if (uid == null) return "User not logged in";
    // Pass Master Key temporarily from constants
    return EncryptionService.decrypt(encrypted, uid, AppConstants.MASTER_KEY);
  }
}
