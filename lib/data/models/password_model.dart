import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore'daki şifre verisini temsil eden model sınıfı.
class PasswordModel {
  /// Firestore doküman ID'si.
  final String id;
  
  /// Şifre başlığı (ör. "Instagram").
  final String title;
  
  /// AES-256 ile şifrelenmiş şifre metni.
  final String encryptedPassword;
  
  /// Oluşturulma tarihi.
  final DateTime? createdAt;

  PasswordModel({
    required this.id,
    required this.title,
    required this.encryptedPassword,
    this.createdAt,
  });

  /// Firestore snapshot'ından model oluşturur.
  factory PasswordModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PasswordModel(
      id: doc.id,
      title: data['title'] ?? '',
      encryptedPassword: data['password'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Modeli JSON formatına çevirir (Firestore yazma işlemi için).
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'password': encryptedPassword,
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
    };
  }
}
