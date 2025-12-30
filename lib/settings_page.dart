import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart'; // VaultyApp'e erişmek için gerekli

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    // Mevcut temanın karanlık olup olmadığını kontrol et
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.redAccent,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    user?.email ?? "Kullanıcı",
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      // Yazı rengi temaya göre otomatik değişsin
                      color: isDark ? Colors.white : Colors.black
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Text("Uygulama Ayarları", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            const Divider(color: Colors.grey),
            
            // --- TEMA DEĞİŞTİRİCİ ---
            ListTile(
              leading: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: Colors.redAccent,
              ),
              title: Text(
                "Karanlık Mod",
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
              trailing: Switch(
                value: isDark,
                activeColor: Colors.redAccent,
                onChanged: (bool val) {
                  // İŞTE SİHİRLİ DOKUNUŞ BURASI:
                  // main.dart içindeki VaultyApp'in state'ine ulaşıp fonksiyonu tetikliyoruz
                  VaultyApp.of(context)?.changeTheme(
                    val ? ThemeMode.dark : ThemeMode.light
                  );
                },
              ),
            ),
            
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.grey),
              title: Text(
                "Vaulty Hakkında",
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
              subtitle: const Text("Versiyon 1.0.0"),
            ),
            
            const Spacer(),
            const Center(
              child: Text("Made by Vaulty Team", style: TextStyle(color: Colors.grey, fontSize: 12)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}