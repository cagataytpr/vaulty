import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'view_models/home_view_model.dart';
import 'package:vaulty/views/home/home_page.dart';
import 'package:vaulty/views/auth/login_screen.dart';
import 'package:vaulty/views/onboarding_screen.dart';
import 'package:vaulty/views/splash_screen.dart'; // Yeni ekranı ekledik
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance.signOut();
  // Test aşamasında her açılışta çıkış yapmak istersen bu kalsın, 
  // ama gerçek kullanımda kullanıcıyı içeride tutmak için bunu yorum satırına alabilirsin.
  // await FirebaseAuth.instance.signOut(); 
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ],
      child: const VaultyApp(),
    ),
  );
}

class VaultyApp extends StatefulWidget {
  const VaultyApp({super.key});

  @override
  State<VaultyApp> createState() => VaultyAppState();

  static VaultyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<VaultyAppState>();
}

class VaultyAppState extends State<VaultyApp> with WidgetsBindingObserver {
  ThemeMode _themeMode = ThemeMode.dark;
  bool _isFirstTime = true;
  bool _isLoading = true;
  Timer? _inactivityTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadInitialData();
    _resetInactivityTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inactivityTimer?.cancel();
    super.dispose();
  }

  // --- ARKA PLAN / FOREGROUND KONTROLÜ ---
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      // Uygulama arka plana atılınca direkt kitle
      _lockApp(); 
    }
  }

  // --- İNAKTİFLİK ZAMANLAYICISI ---
  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    // Kullanıcı giriş yapmamışsa sayaç çalışmasın
    if (FirebaseAuth.instance.currentUser == null) return;

    _inactivityTimer = Timer(const Duration(minutes: 1), () {
      _lockApp();
    });
  }

  void _lockApp() {
    _inactivityTimer?.cancel();
    // Eğer zaten login ekranındaysak tekrar açmaya çalışma (mounted kontrolü ile)
    if (!mounted) return;
    
    // Sadece kullanıcı giriş yapmışsa kitleme işlemi yap
    if (FirebaseAuth.instance.currentUser != null) {
      // Güvenlik için stack'i temizleyip Login'e at
      // Not: navigatorKey kullanmıyoruz, bu yüzden context erişimi önemli.
      // Ancak VaultyApp en tepede olduğu için kendi navigator'ı yok.
      // Bu yüzden MaterialApp içindeki navigator'a buradan erişemeyiz.
      // ÇÖZÜM: `GlobalKey<NavigatorState>` kullanmak en temizi olurdu ama
      // burada mevcut yapıyı bozmadan main.dart içinde _lockApp'i tetikleyemeyiz.
      // FAKAT: VaultyApp bir StatefulWidget ve build içinde MaterialApp dönüyor.
      // Lock işlemi aslında bir state değişikliği veya navigation gerektirir.
      
      // Basit çözüm: Kullanıcıyı sign-out yapıp UI'ı güncellemek? 
      // Hayır, sign-out yaparsak biyometrik ile hızlı giriş olmaz, şifre ister.
      // İstenen: "Navigate to LoginScreen immediately".
      
      // Global Navigation Key ekleyelim.
      navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
    }
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

    return Listener(
      onPointerDown: (_) => _resetInactivityTimer(),
      onPointerMove: (_) => _resetInactivityTimer(),
      onPointerUp: (_) => _resetInactivityTimer(),
      child: MaterialApp(
        navigatorKey: navigatorKey, // Global Key Eklendi
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
        
        // Rota tanımları ekleyelim ki navigatorKey ile kolayca gidelim
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomePage(),
        },
        
        // ARTIK BAŞLANGIÇ NOKTAMIZ SPLASH SCREEN!
        home: const SplashScreen(), 
      ),
    );
  }
}

// Global Navigator Key tanımladık ki context olmadan navigation yapabilelim
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();