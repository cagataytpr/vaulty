import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vaulty/login_screen.dart';
import 'package:vaulty/onboarding_screen.dart';
import 'firebase_options.dart'; // Otomatik oluşan dosyan
import 'registerscreen.dart';

void main() async {
  // Flutter widgetlarını ve Firebase'i hazırla
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const VaultyApp());
}

class VaultyApp extends StatelessWidget {
  const VaultyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vaulty',
      debugShowCheckedModeBanner: false,
      // BURASI ÖNEMLİ: Senin istediğin kırmızı tema temelleri
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: const Color(
          0xFF0F0F0F,
        ), // Derin siyah/antrasit
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.dark,
          primary: Colors.redAccent,
        ),
      ),
      home: const OnboardingScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 80, color: Colors.redAccent),
            const SizedBox(height: 20),
            const Text(
              'VAULTY',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
                color: Colors.white,
              ),
            ),
            const Text(
              'Güvenli Alan Hazır',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // HomeScreen içindeki butonun onPressed kısmını böyle değiştir:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              child: const Text(
                'Keşfetmeye Başla',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
