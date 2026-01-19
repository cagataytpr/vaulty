/// Uygulama genelinde kullanılan sabit değerler.
class AppConstants {
  /// Uygulama adı.
  static const String appName = 'Vaulty';
  
  /// Uygulama versiyonu.
  static const String appVersion = '1.0.0';
  
  /// Veritabanı (Firestore) koleksiyon isimleri.
  static const String usersCollection = 'users';
  static const String passwordsCollection = 'passwords';
  
  /// SharedPreferences anahtarları.
  static const String prefsThemeKey = 'theme_mode';
  static const String prefsLanguageKey = 'language_code';
  static const String prefsLastCheckKey = 'last_security_check';
  
  /// Secure Storage anahtarları.
  static const String secureStorageMasterKey = 'vaulty_master_key';
}
