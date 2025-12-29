import 'package:flutter/material.dart';
import 'package:vaulty/main.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: onboardingData.length,
            itemBuilder: (context, index) {
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
                    child: Text(onboardingData[index]['text']!, textAlign: TextAlign.center),
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: _currentPage == onboardingData.length - 1
                ? ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen())),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                    child: const Text("Hadi Başlayalım!", style: TextStyle(color: Colors.white)),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(onPressed: () => _controller.jumpToPage(2), child: const Text("Atla")),
                      Row(
                        children: List.generate(3, (index) => Container(
                          margin: const EdgeInsets.all(4),
                          width: _currentPage == index ? 20 : 8,
                          height: 8,
                          decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(10)),
                        )),
                      ),
                      TextButton(onPressed: () => _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.ease), child: const Text("İleri")),
                    ],
                  ),
          )
        ],
      ),
    );
  }
}