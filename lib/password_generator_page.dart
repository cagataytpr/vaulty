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
    // LayoutBuilder kullanarak ekran yüksekliğini alıyoruz ki 
    // içerik kısa kalsa bile butonu en alta itebilelim.
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Elemanları yay
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        // Üretilen Şifre Alanı
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
                          ),
                          child: Column(
                            children: [
                              Text(
                                _generatedPassword,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.redAccent, 
                                  fontSize: _generatedPassword.length > 20 ? 18 : 24, // Uzun şifre sığsın
                                  fontWeight: FontWeight.bold, 
                                  letterSpacing: 1.5
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: _generatedPassword));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Kopyalandı!"), backgroundColor: Colors.green)
                                  );
                                },
                                icon: const Icon(Icons.copy, size: 18),
                                label: const Text("Kopyala"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white12, 
                                  foregroundColor: Colors.white
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        
                        // Ayarlar
                        _buildOption("Uzunluk: ${_length.toInt()}", 
                          Expanded( // Slider'ı Row içinde Expanded yaptık
                            child: Slider(
                              value: _length,
                              min: 8, max: 32,
                              activeColor: Colors.redAccent,
                              onChanged: (val) => setState(() => _length = val),
                            ),
                          )
                        ),
                        _buildOption("Büyük Harf", Switch(value: _hasCapital, activeTrackColor: Colors.redAccent, onChanged: (val) => setState(() => _hasCapital = val))),
                        _buildOption("Sayılar", Switch(value: _hasNumbers, activeTrackColor: Colors.redAccent, onChanged: (val) => setState(() => _hasNumbers = val))),
                        _buildOption("Semboller", Switch(value: _hasSpecial, activeTrackColor: Colors.redAccent, onChanged: (val) => setState(() => _hasSpecial = val))),
                      ],
                    ),
                    
                    // Spacer yerine Padding kullanarak butonu en alta sabitliyoruz
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: ElevatedButton(
                        onPressed: _generate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent, 
                          minimumSize: const Size(double.infinity, 60), 
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                        ),
                        child: const Text("YENİ ÜRET", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildOption(String title, Widget control) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 110, // Yazı alanı sabit kalsın ki slider kaymasın
            child: Text(title, style: const TextStyle(fontSize: 16))
          ),
          control,
        ],
      ),
    );
  }
}