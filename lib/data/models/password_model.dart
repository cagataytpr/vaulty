import 'package:cloud_firestore/cloud_firestore.dart';

class PasswordModel {
  final String id;
  final String title;
  final String encryptedPassword;
  final DateTime? createdAt;

  PasswordModel({
    required this.id,
    required this.title,
    required this.encryptedPassword,
    this.createdAt,
  });

  factory PasswordModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PasswordModel(
      id: doc.id,
      title: data['title'] ?? '',
      encryptedPassword: data['password'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'password': encryptedPassword,
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
    };
  }
}
