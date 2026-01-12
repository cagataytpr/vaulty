import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class PasswordGeneratorPage extends StatefulWidget {
  const PasswordGeneratorPage({super.key});

  @override
  State<PasswordGeneratorPage> createState() => _PasswordGeneratorPageState();
}

class _PasswordGeneratorPageState extends State<PasswordGeneratorPage> {
  double _length = 12;
  bool _hasNumbers = true;
  bool _hasSpecial = true;
  bool _hasCapital = true;
  String _generatedPassword = "";

  void _generate() {
    const letters = "abcdefghijklmnopqrstuvwxyz";
    const capitalLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const numbers = "0123456789";
    const special = "!@#\$%^&*()_+=-[]{}|;:,.<>?";

    String chars = letters;
    if (_hasCapital) chars += capitalLetters;
    if (_hasNumbers) chars += numbers;
    if (_hasSpecial) chars += special;

    setState(() {
      _generatedPassword = List.generate(_length.toInt(), (index) {
        return chars[Random().nextInt(chars.length)];
      }).join();
    });
  }

  @override
  void initState() {
    super.initState();
    _generate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        // Sayfa sonuna gelince tatlı bir esneme yapar
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- ÜRETİLEN ŞİFRE ALANI (GLASS PANEL) ---
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
                  boxShadow: [
                    BoxShadow(color: Colors.redAccent.withValues(alpha: 0.05), blurRadius: 20, spreadRadius: 2),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      _generatedPassword,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: _generatedPassword.length > 20 ? 20 : 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        shadows: [Shadow(color: Colors.redAccent.withValues(alpha: 0.3), blurRadius: 10)],
                      ),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _generatedPassword));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Kopyalandı!"), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating),
                        );
                      },
                      icon: const Icon(Icons.copy_all_rounded, size: 20),
                      label: const Text("KOPYALA"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              // --- AYARLAR BAŞLIĞI ---
              const Text("GÜVENLİK PARAMETRELERİ", 
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 12)),
              const SizedBox(height: 15),

              // --- AYARLAR PANELİ ---
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Column(
                  children: [
                    _buildOption("Uzunluk: ${_length.toInt()}", 
                      Expanded(
                        child: Slider(
                          value: _length,
                          min: 8, max: 32,
                          activeColor: Colors.redAccent,
                          inactiveColor: Colors.white10,
                          onChanged: (val) => setState(() => _length = val),
                        ),
                      )
                    ),
                    const Divider(color: Colors.white10, indent: 20, endIndent: 20),
                    _buildOption("Büyük Harf", Switch(value: _hasCapital, activeThumbColor: Colors.redAccent, onChanged: (val) => setState(() => _hasCapital = val))),
                    _buildOption("Sayılar", Switch(value: _hasNumbers, activeThumbColor: Colors.redAccent, onChanged: (val) => setState(() => _hasNumbers = val))),
                    _buildOption("Semboller", Switch(value: _hasSpecial, activeThumbColor: Colors.redAccent, onChanged: (val) => setState(() => _hasSpecial = val))),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // --- ÜRET BUTONU ---
              ElevatedButton(
                onPressed: _generate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: const Size(double.infinity, 65),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 10,
                  shadowColor: Colors.redAccent.withValues(alpha: 0.4),
                ),
                child: const Text("YENİ ŞİFRE OLUŞTUR", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),

              // 🚀 KRİTİK: Butonu SnakeNavigationBar'ın altından kurtaran boşluk
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(String title, Widget control) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(title, style: const TextStyle(fontSize: 15, color: Colors.white70))),
          control,
        ],
      ),
    );
  }
}