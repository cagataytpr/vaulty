import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Uygulama dil/lokalizasyon durumunu yöneten ViewModel.
class LocaleViewModel extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  LocaleViewModel() {
    _loadLocale();
  }

  /// Kaydedilmiş dil tercihini yükler (SharedPreferences).
  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString('language_code');
    if (languageCode != null) {
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }

  /// Uygulama dilini değiştirir ve tercihi kaydeder.
  /// 
  /// Desteklenen diller: 'en', 'tr', 'de', 'es', 'fr'.
  Future<void> setLocale(Locale locale) async {
    if (!['en', 'tr', 'de', 'es', 'fr'].contains(locale.languageCode)) return;
    
    _locale = locale;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
  }

  /// Kayıtlı dil tercihini siler ve sistem varsayılanına döner.
  Future<void> clearLocale() async {
    _locale = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('language_code');
  }
}
