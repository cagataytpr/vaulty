import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vaulty/home_page.dart';
import 'package:vaulty/login_screen.dart';
import 'package:vaulty/onboarding_screen.dart';
import 'package:vaulty/splash_screen.dart'; // Yeni ekranı ekledik
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance.signOut();
  // Test aşamasında her açılışta çıkış yapmak istersen bu kalsın, 
  // ama gerçek kullanımda kullanıcıyı içeride tutmak için bunu yorum satırına alabilirsin.
  // await FirebaseAuth.instance.signOut(); 
  
  runApp(const VaultyApp());
}

class VaultyApp extends StatefulWidget {
  const VaultyApp({super.key});

  static VaultyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<VaultyAppState>();

  @override
  State<VaultyApp> createState() => VaultyAppState();
}

class VaultyAppState extends State<VaultyApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  bool _isFirstTime = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

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

  void completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
    setState(() {
      _isFirstTime = false;
    });
  }

  void changeTheme(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = themeMode;
      prefs.setBool('isDarkMode', themeMode == ThemeMode.dark);
    });
  }

  // --- KRİTİK FONKSİYON: SplashScreen'den sonra nereye gidilecek? ---
  Widget getNextScreen() {
    // 1. Eğer uygulama ilk kez açılıyorsa Onboarding'e gönder
    if (_isFirstTime) {
      return const OnboardingScreen();
    }
    
    // 2. Kullanıcı giriş yapmış mı ve maili onaylı mı kontrol et
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      return const HomePage();
    }
    
    // 3. Hiçbiri değilse Login'e gönder
    return const LoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    // Veriler yüklenirken siyah bir ekran yerine SplashScreen mantığına uygun bekleme yapıyoruz
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
      
      // ARTIK BAŞLANGIÇ NOKTAMIZ SPLASH SCREEN!
      home: const SplashScreen(), 
    );
  }
}