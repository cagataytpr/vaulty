import 'package:flutter/material.dart';
import 'package:vaulty/main.dart';
import 'package:vaulty/views/auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  // Verileri siber temaya göre güncelledik
  List<Map<String, dynamic>> onboardingData = [
    {
      "title": "Tüm Şifrelerin Güvende",
      "text": "Vaulty ile şifrelerini tek bir noktada, askeri düzeyde şifrelemeyle sakla.",
      "icon": Icons.enhanced_encryption_rounded
    },
    {
      "title": "Hızlı Erişim",
      "text": "İstediğin sırra saniyeler içinde ulaş, güvenle kopyala ve kullan.",
      "icon": Icons.bolt_rounded
    },
    {
      "title": "Sadece Senin İçin",
      "text": "Verilerin sadece senin cihazında üretilen anahtarlarla korunur.",
      "icon": Icons.fingerprint_rounded
    },
    {
      "title": "VAULTY",
      "text": "Güvenli Alan Hazır",
      "icon": "logo" 
    },
  ];

  @override
  Widget build(BuildContext context) {
    bool isLastPage = _currentPage == onboardingData.length - 1;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: onboardingData.length,
            itemBuilder: (context, index) {
              if (index == onboardingData.length - 1) {
                return _buildFinalPage();
              }

              return Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // İkon Alanı (Parlayan Efektli)
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.1)),
                      ),
                      child: Icon(
                        onboardingData[index]['icon'],
                        size: 100,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Text(
                      onboardingData[index]['title']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      onboardingData[index]['text']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey, fontSize: 16, height: 1.5),
                    ),
                  ],
                ),
              );
            },
          ),
          
          // Kontroller
          if (!isLastPage)
            Positioned(
              bottom: 60,
              left: 30,
              right: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => _controller.jumpToPage(onboardingData.length - 1),
                    child: const Text("ATLA", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                  ),
                  Row(
                    children: List.generate(
                      onboardingData.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 4,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? Colors.redAccent : Colors.grey.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOutQuart),
                    icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.redAccent, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget _buildFinalPage() {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Alanı
            Container(
              width: 160,
              height: 160,
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
            const SizedBox(height: 30),
            Text(
              'VAULTY',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const Text(
              'Terminal Erişimi Hazır',
              style: TextStyle(color: Colors.grey, fontSize: 16, letterSpacing: 2),
            ),
            const SizedBox(height: 80),
            
            // Keşfet Butonu (Neon Tasarım)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  VaultyApp.of(context)?.completeOnboarding();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 65),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                child: const Text(
                  'SİSTEMİ BAŞLAT',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}