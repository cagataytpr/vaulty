import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart'; // Giriş ekranına yönlendirme için

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  // --- SENİN SAĞLAM BACKEND MANTIĞIN ---
  Future<void> registerUser() async {
    setState(() => _isLoading = true);

    try {
      // 1. Kullanıcıyı oluştur
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 2. Doğrulama mailini gönder
      await userCredential.user?.sendEmailVerification();

      // 3. KRİTİK ADIM: Oturumu hemen kapatıyoruz.
      // Bu sayede onaysız token ile ana sayfaya sızıp hata almasını engelliyoruz.
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      // Kullanıcıya bilgi mesajı göster
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kayıt başarılı! Lütfen mailini onayla ve giriş yap."),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 5),
        ),
      );

      // 4. Login ekranına geri uçur (Arkadaki tüm sayfaları temizle)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );

    } catch (e) {
      setState(() => _isLoading = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Hata: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F), // Ultra Dark Tema
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                // Logo Alanı
                Hero(
                  tag: 'logo',
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.redAccent.withOpacity(0.2),
                          blurRadius: 50,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Image.asset('assets/logo.png', fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "YENİ ERİŞİM",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Vaulty Terminaline Kayıt Ol",
                  style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12),
                ),

                const SizedBox(height: 50),

                // --- INPUTLAR (GLASSMORPHISM) ---
                _buildGlassInput(
                  controller: _emailController,
                  label: "Email",
                  icon: Icons.alternate_email_rounded,
                ),
                const SizedBox(height: 20),
                _buildGlassInput(
                  controller: _passwordController,
                  label: "Şifre",
                  icon: Icons.lock_open_rounded,
                  isPassword: true,
                ),

                const SizedBox(height: 40),

                // --- KAYIT BUTONU ---
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text("ERİŞİM OLUŞTUR", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  ),
                ),
                
                const SizedBox(height: 25),

                // Giriş Linki
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: RichText(
                    text: TextSpan(
                      text: "Zaten hesabın var mı? ",
                      style: TextStyle(color: Colors.white.withOpacity(0.5)),
                      children: const [
                        TextSpan(
                          text: "GİRİŞ YAP",
                          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- GLASSMORPHISM INPUT TASARIMI ---
  Widget _buildGlassInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
          prefixIcon: Icon(icon, color: Colors.redAccent.withOpacity(0.7)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}