import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vaulty/login_screen.dart';
import 'package:vaulty/onboarding_screen.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const VaultyApp());
}

class VaultyApp extends StatefulWidget {
  const VaultyApp({super.key});

  static _VaultyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_VaultyAppState>();

  @override
  State<VaultyApp> createState() => _VaultyAppState();
}

class _VaultyAppState extends State<VaultyApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  bool _isFirstTime = true;
  bool _isLoading = true; // Alt tireli olanı standart yaptık

  @override
  void initState() {
    super.initState();
    _loadInitialData(); // Tek fonksiyon her şeyi halleder
  }

  // Hafızadaki tüm ayarları tek seferde yükleyen fonksiyon
  Future<void> _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // 1. Tema Kontrolü
      bool isDark = prefs.getBool('isDarkMode') ?? true;
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      
      // 2. Tanıtım Ekranı Kontrolü
      _isFirstTime = prefs.getBool('isFirstTime') ?? true;
      
      _isLoading = false; 
    });
  }

  // Tanıtım bittiğinde çağıracağın fonksiyon
  void completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
    setState(() {
      _isFirstTime = false;
    });
  }

  // Temayı değiştiren ve kaydeden fonksiyon
  void changeTheme(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = themeMode;
      prefs.setBool('isDarkMode', themeMode == ThemeMode.dark);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Veriler yüklenirken boş siyah ekran veya loading göster
    if (_isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFF0F0F0F),
          body: Center(child: CircularProgressIndicator(color: Colors.redAccent)),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vaulty',
      
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.redAccent,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red, brightness: Brightness.light),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        primaryColor: Colors.redAccent,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red, brightness: Brightness.dark),
      ),

      themeMode: _themeMode,
      // MANTIK: İlk girişse Onboarding, değilse Giriş/Home ekranı
      home: _isFirstTime ? const OnboardingScreen() : const LoginScreen(),
    );
  }
}
