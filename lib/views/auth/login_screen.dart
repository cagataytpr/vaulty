import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vaulty/data/services/auth_service.dart';
import '../home/home_page.dart';
import 'package:vaulty/views/auth/registerscreen.dart';
import 'package:vaulty/views/auth/email_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> resetPassword() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kuzen önce mailini yaz ki kime göndereceğimizi bilelim!")),
      );
      return;
    }
    try {
      await AuthService.sendPasswordReset(_emailController.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Şifre sıfırlama linki mailine uçtu!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: ${e.toString()}")),
      );
    }
  }

  Future<void> loginUser() async {
    setState(() => _isLoading = true);
    try {
      UserCredential userCredential = await AuthService.loginWithEmail(
        _emailController.text,
        _passwordController.text,
      );

      if (!mounted) return;

      if (userCredential.user != null) {
        if (userCredential.user!.emailVerified) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          setState(() => _isLoading = false);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EmailVerificationScreen()),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Giriş Başarısız: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // --- DEV MODE ---
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      _emailController.text = "11feyza@gmail.com";
                      _passwordController.text = "11feyza@gmail.com";
                      loginUser();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
                      ),
                      child: const Text("DEV MODE", style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // --- LOGO ---
                Column(
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withValues(alpha: 0.2),
                            blurRadius: 50,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Image.asset('assets/logo.png', fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 15),
                    const Text("VAULTY", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 4)),
                    Text("SECURE DATA TERMINAL", style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 10, letterSpacing: 2)),
                  ],
                ),

                const SizedBox(height: 50),

                // --- INPUTS ---
                _buildGlassInput(controller: _emailController, label: "Email", icon: Icons.alternate_email_rounded),
                const SizedBox(height: 20),
                _buildGlassInput(controller: _passwordController, label: "Şifre", icon: Icons.lock_outline_rounded, isPassword: true),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: resetPassword,
                    child: Text("Şifremi Unuttum", style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
                  ),
                ),

                const SizedBox(height: 20),

                // --- LOGIN BUTTON ---
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(color: Colors.redAccent.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 5)),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : loginUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("SİSTEME GİRİŞ YAP", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  ),
                ),

                const SizedBox(height: 15),

                // --- KAYIT OL LİNKİ (BURAYA EKLENDİ) ---
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Erişimin yok mu? ",
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
                      children: const [
                        TextSpan(
                          text: "KAYIT OL",
                          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
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

  Widget _buildGlassInput({required TextEditingController controller, required String label, required IconData icon, bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
          prefixIcon: Icon(icon, color: Colors.redAccent.withValues(alpha: 0.7)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}
