import 'package:flutter/material.dart';
import 'package:vaulty/main.dart';
import 'package:vaulty/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  // Veri listesine en son "Keşfet" sayfasını ekledik
  List<Map<String, String>> onboardingData = [
    {
      "title": "Tüm Şifrelerin Güvende",
      "text": "Vaulty ile şifrelerini tek bir noktada, şifreli bir şekilde sakla.",
      "icon": "🔐"
    },
    {
      "title": "Hızlı Erişim",
      "text": "İstediğin şifreye saniyeler içinde ulaş, kopyala ve kullan.",
      "icon": "⚡"
    },
    {
      "title": "Sadece Senin İçin",
      "text": "Verilerin sadece senin erişebileceğin özel bir kasada tutulur.",
      "icon": "🛡️"
    },
    // İŞTE YENİ FİNAL SAYFASI VERİSİ
    {
      "title": "VAULTY",
      "text": "Güvenli Alan Hazır",
      "icon": "logo" // Burayı özel render edeceğiz
    },
  ];

  @override
  Widget build(BuildContext context) {
    bool isLastPage = _currentPage == onboardingData.length - 1;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: onboardingData.length,
            itemBuilder: (context, index) {
              // Eğer son sayfadaysak farklı bir tasarım basıyoruz (Senin HomeScreen tasarımı)
              if (index == onboardingData.length - 1) {
                return _buildFinalPage();
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(onboardingData[index]['icon']!, style: const TextStyle(fontSize: 100)),
                  const SizedBox(height: 40),
                  Text(
                    onboardingData[index]['title']!,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.redAccent),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      onboardingData[index]['text']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ],
              );
            },
          ),
          
          // Alt kısımdaki kontroller (Sadece son sayfada değilken gösterelim)
          if (!isLastPage)
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: () => _controller.jumpToPage(onboardingData.length - 1), child: const Text("Atla", style: TextStyle(color: Colors.grey))),
                  Row(
                    children: List.generate(onboardingData.length, (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.all(4),
                      width: _currentPage == index ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(10)),
                    )),
                  ),
                  TextButton(onPressed: () => _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.ease), child: const Text("İleri", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold))),
                ],
              ),
            )
        ],
      ),
    );
  }

  // Senin o meşhur HomeScreen tasarımını buraya metod olarak aldım
  Widget _buildFinalPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, size: 100, color: Colors.redAccent),
          const SizedBox(height: 20),
          const Text(
            'VAULTY',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 6, color: Colors.redAccent),
          ),
          const Text('Güvenli Alan Hazır', style: TextStyle(color: Colors.grey, fontSize: 18)),
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              onPressed: () {
                // Hem Onboarding'i hem Discovery'yi (Keşfet) bitiriyoruz
                VaultyApp.of(context)?.completeOnboarding();
                // Buradaki completeDiscovery fonksiyonunu main.dart'a eklemiştik
                // Eğer hata alırsan main'de o fonksiyonun adını kontrol et
                
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('KEŞFETMEYE BAŞLA', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}