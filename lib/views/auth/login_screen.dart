import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vaulty/data/services/auth_service.dart';
import 'package:vaulty/l10n/app_localizations.dart';
import '../home/home_page.dart';
import 'package:vaulty/views/auth/registerscreen.dart';





class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  User? _currentUser;



  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseEnterEmail)),
      );
      return;
    }
    try {
      await AuthService.sendPasswordReset(_emailController.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.passwordResetSent),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${AppLocalizations.of(context)!.errorPrefix}${e.toString()}")),
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
        // Strict Verification Logic
        await userCredential.user!.reload();
        if (!userCredential.user!.emailVerified) {
          await FirebaseAuth.instance.signOut();
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.emailNotVerified),
              backgroundColor: Colors.red,
            ),
          );
          setState(() => _isLoading = false);
          return;
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${AppLocalizations.of(context)!.loginFailed}${e.toString()}")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<void> _unlockWithBiometrics() async {
    final l10n = AppLocalizations.of(context)!;
    bool authenticated = await AuthService.authenticateUser(localizedReason: l10n.biometricReason);
    if (authenticated) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.biometricError)),
      );
    }
  }

  Future<void> signOut() async {
    await AuthService.signOut();
    setState(() {
      _currentUser = null;
      _emailController.clear();
      _passwordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser != null) {
      return _buildLockedMode();
    }
    return _buildLoginMode();
  }

  Widget _buildLockedMode() {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                  border: Border.all(color: Colors.redAccent.withValues(alpha: 0.2), width: 2),
                ),
                child: const Icon(Icons.lock_outline_rounded, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 30),
              
              Text(AppLocalizations.of(context)!.welcomeBack.toUpperCase(), 
                style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)),
              const SizedBox(height: 10),
              Text(_currentUser?.email ?? "Kullanıcı", 
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 50),

              // Unlock Button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(color: Colors.redAccent.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 5)),
                    ],
                  ),
                child: ElevatedButton.icon(
                  onPressed: _unlockWithBiometrics,
                  icon: const Icon(Icons.fingerprint_rounded, size: 28),
                  label: Text(AppLocalizations.of(context)!.unlockBiometric.toUpperCase(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              TextButton(
                onPressed: signOut, 
                child: Text(AppLocalizations.of(context)!.signOut, style: TextStyle(color: Colors.white.withValues(alpha: 0.5))),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginMode() {
    final l10n = AppLocalizations.of(context)!;

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
                        color: Colors.amber.withValues(alpha:0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber.withValues(alpha:0.5)),
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
                            color: Colors.redAccent.withValues(alpha:0.2),
                            blurRadius: 50,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Image.asset('assets/logo.png', fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 15),
                    Text(l10n.appTitle.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 4)),
                    Text("SECURE DATA TERMINAL", style: TextStyle(color: Colors.white.withValues(alpha:0.4), fontSize: 10, letterSpacing: 2)),
                  ],
                ),

                const SizedBox(height: 50),

                // --- INPUTLAR (GLASSMORPHISM) ---
                _buildGlassInput(
                  controller: _emailController,
                  label: l10n.email,
                  icon: Icons.alternate_email_rounded,
                ),
                const SizedBox(height: 20),
                _buildGlassInput(
                  controller: _passwordController,
                  label: l10n.password,
                  icon: Icons.lock_open_rounded,
                  isPassword: true,
                ),

                // Şifremi Unuttum
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: resetPassword,
                    child: Text(l10n.forgotPassword, style: const TextStyle(color: Colors.white70)),
                  ),
                ),

                const SizedBox(height: 30),

                // --- GİRİŞ BUTONU ---
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withValues(alpha:0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
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
                        ? const SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(l10n.login.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  ),
                ),
                
                const SizedBox(height: 25),

                // Kayıt Ol Linki
                TextButton(
                  onPressed: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "${l10n.dontHaveAccount} ",
                      style: TextStyle(color: Colors.white.withValues(alpha:0.5)),
                      children: [
                        TextSpan(
                          text: l10n.register.toUpperCase(),
                          style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
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
