import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'encryption_service.dart';


class AddPasswordSheet extends StatefulWidget {
  const AddPasswordSheet({super.key});

  @override
  State<AddPasswordSheet> createState() => _AddPasswordSheetState();
}

class _AddPasswordSheetState extends State<AddPasswordSheet> {
  final _titleController = TextEditingController();
  final _passController = TextEditingController();

  // Şifre Gücü Hesaplama
  Map<String, dynamic> _checkStrength(String password) {
    if (password.isEmpty) return {"label": "", "color": Colors.transparent, "percent": 0.0};
    
    double strength = 0;
    if (password.length >= 8) strength += 0.25;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.25;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.25;

    if (strength <= 0.25) return {"label": "Çok Zayıf", "color": Colors.red, "percent": 0.25};
    if (strength <= 0.50) return {"label": "Zayıf", "color": Colors.orange, "percent": 0.50};
    if (strength <= 0.75) return {"label": "İyi", "color": Colors.blue, "percent": 0.75};
    return {"label": "Mükemmel!", "color": Colors.green, "percent": 1.0};
  }

  void _saveToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _titleController.text.isNotEmpty) {
      // ÇÖZÜM: Hem şifreyi hem de user.uid'yi gönderiyoruz
      String encryptedText = EncryptionService.encrypt(
        _passController.text, 
        user.uid
      );
      
      await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('passwords').add({
        'title': _titleController.text,
        'password': encryptedText,
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var strength = _checkStrength(_passController.text);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20, right: 20, top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // En üste minik bir tutamaç (handle) ekleyelim, modern dursun
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(10)),
          ),
          const SizedBox(height: 20),
          const Text("Yeni Şifre Ekle", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 25),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: "Başlık (Örn: Gmail)", 
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.title),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _passController,
            onChanged: (value) => setState(() {}),
            obscureText: true, // Şifreyi gizli yazsın
            decoration: const InputDecoration(
              labelText: "Şifre", 
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock_outline),
            ),
          ),
          
          if (_passController.text.isNotEmpty) ...[
            const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: strength["percent"],
                backgroundColor: Colors.white10,
                valueColor: AlwaysStoppedAnimation<Color>(strength["color"]),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Güvenlik: ${strength["label"]}",
                style: TextStyle(color: strength["color"], fontWeight: FontWeight.bold),
              ),
            ),
          ],

          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _saveToFirebase,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent, 
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("KAYDET", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}