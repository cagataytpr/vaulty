import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vaulty/data/services/auth_service.dart';
import 'package:vaulty/views/home/home_page.dart';
import 'package:vaulty/l10n/app_localizations.dart';

/// E-posta doğrulama ekranı.
/// 
/// Kullanıcı kayıt olduktan sonra e-postasını onaylaması için gösterilen bekleme ekranıdır.
class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // Sayfa açıldığında doğrulama e-postası gönder
    AuthService.sendVerificationEmail();

    // Her 3 saniyede bir doğrulama durumunu kontrol et
    timer = Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  Future checkEmailVerified() async {
    // Firebase'den güncel kullanıcı durumunu çek
    await FirebaseAuth.instance.currentUser?.reload(); 
    
    // Doğrulama durumunu kontrol et
    bool verified = FirebaseAuth.instance.currentUser!.emailVerified;
    
    if (verified) {
      // Doğrulama başarılıysa ana sayfaya yönlendir
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mail_outline, size: 100, color: Colors.amber),
            const SizedBox(height: 20),
            Text(l10n.emailSentTitle, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(l10n.checkSpam, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => AuthService.sendVerificationEmail(),
              child: Text(l10n.resend),
            ),
            TextButton(
              onPressed: () async {
                await AuthService.signOut();
                if (context.mounted) Navigator.pop(context);
              },
              child: Text(l10n.cancelAndLogout),
            ),
          ],
        ),
      ),
    );
  }
}