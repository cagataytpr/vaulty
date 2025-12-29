import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vaulty Kasa"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(), // Çıkış yap
          ),
        ],
      ),
      body: const Center(
        child: Text("Şifrelerin ve Görevlerin Burada Olacak!"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () {
          // Yeni şifre ekleme butonu
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}