import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart'; // Yönlendirme yapacağımız sayfa

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // 1. BURAYA EKLEDİK: Butona basıldığında dönen halkayı kontrol eden değişken
  bool _isLoading = false;

  Future<void> registerUser() async {
    // 2. BURADA AKTİF EDİYORUZ: İşlem başladığında yükleniyor yap
    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vaulty'ye hoş geldin! Kayıt başarılı.")),
      );

      // Ana sayfaya uçur
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      // 3. BURADA KAPATIYORUZ: Hata olursa halkayı durdur ki kullanıcı tekrar denesin
      setState(() => _isLoading = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hesap Oluştur")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email, color: Colors.redAccent),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Şifre",
                prefixIcon: Icon(Icons.lock, color: Colors.redAccent),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            
            // 4. BUTON BURADA: Eğer yükleniyorsa halka göster, değilse yazı
            ElevatedButton(
              onPressed: _isLoading ? null : registerUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isLoading 
                ? const SizedBox(
                    height: 20, 
                    width: 20, 
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                  )
                : const Text("Kayıt Ol", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}