// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Vaulty';

  @override
  String get login => 'Giriş Yap';

  @override
  String get register => 'Kayıt Ol';

  @override
  String get email => 'E-posta Adresi';

  @override
  String get password => 'Şifre';

  @override
  String get forgotPassword => 'Şifremi Unuttum';

  @override
  String get dontHaveAccount => 'Hesabınız yok mu?';

  @override
  String get emailNotVerified =>
      'E-posta adresiniz doğrulanmamış. Lütfen gelen kutunuzu kontrol edin.';

  @override
  String get unlockBiometric => 'Kasanın Kilidini Aç';

  @override
  String get signOut => 'Çıkış Yap';

  @override
  String get securityReportTitle => 'GÜVENLİK ANALİZ RAPORU';

  @override
  String securityRiskFound(int count) {
    return '$count güvenlik riski bulundu. İncelemek için dokunun.';
  }

  @override
  String get securityNoRisks => 'Harika! Tüm şifreleriniz güvende.';

  @override
  String get riskWeak => 'Şifre çok kısa (Zayıf)';

  @override
  String get riskReused => 'Bu şifre başka bir hesapta da kullanılıyor';

  @override
  String get secureSession => 'GÜVENLİ OTURUM';

  @override
  String get preferences => 'TERCİHLER';

  @override
  String get system => 'SİSTEM';

  @override
  String get about => 'Vaulty Hakkında';

  @override
  String get settings => 'Ayarlar';

  @override
  String get searchPlaceholder => 'Kasanızda arayın...';

  @override
  String get emptyVault => 'Kasanız şu an sessiz.';

  @override
  String get emptyVaultSub => 'Başlamak için ilk şifrenizi ekleyin.';

  @override
  String get welcomeBack => 'Tekrar Hoş Geldiniz';

  @override
  String get myVault => 'Kasam';

  @override
  String get addPassword => 'Şifre Ekle';

  @override
  String get darkMode => 'Karanlık Mod';

  @override
  String get language => 'Dil';

  @override
  String get exportPdf => 'PDF Olarak Dışa Aktar';

  @override
  String get cancel => 'İptal';

  @override
  String get delete => 'Sil';

  @override
  String get save => 'Kaydet';

  @override
  String get edit => 'Düzenle';

  @override
  String get copySuccess =>
      'Panoya kopyalandı! Güvenlik için 45sn sonra silinecek.';

  @override
  String get deleteConfirmation =>
      'Bu şifreyi silmek istediğinize emin misiniz? Bu işlem geri alınamaz.';

  @override
  String get biometricReason =>
      'İşlem yapmak için lütfen kimliğinizi doğrulayın';

  @override
  String get biometricUnlock => 'Kilidi Biyometrik ile Aç';

  @override
  String get errorGeneric => 'Bir hata oluştu.';

  @override
  String get loading => 'Yükleniyor...';

  @override
  String get version => 'Sürüm';

  @override
  String get noPasswords => 'Dışa aktarılacak şifre yok.';

  @override
  String get alreadyHaveAccount => 'Zaten hesabınız var mı?';

  @override
  String get fullName => 'Ad Soyad';

  @override
  String get passwordsDoNotMatch => 'Şifreler eşleşmiyor';

  @override
  String get passwordResetSent =>
      'Şifre sıfırlama bağlantısı e-postanıza gönderildi.';

  @override
  String get pleaseEnterEmail => 'Lütfen önce e-posta adresinizi giriniz.';

  @override
  String get registerSuccess =>
      'Kayıt başarılı! Lütfen e-postanı onayla ve giriş yap.';

  @override
  String get createAccess => 'Erişim Oluştur';

  @override
  String get newAccess => 'Yeni Erişim';

  @override
  String get registerTerminalTitle => 'Vaulty Terminaline Kayıt Ol';

  @override
  String get generatePassword => 'Şifre Oluştur';

  @override
  String get copyPassword => 'Şifreyi Kopyala';

  @override
  String get length => 'Uzunluk';

  @override
  String get includeNumbers => 'Rakamlar';

  @override
  String get includeSymbols => 'Semboller';

  @override
  String get includeUppercase => 'Büyük Harfler';

  @override
  String get copied => 'Kopyalandı!';

  @override
  String get securityParameters => 'Güvenlik Parametreleri';

  @override
  String get websiteName => 'Web Sitesi / Uygulama Adı';

  @override
  String get secretPassword => 'Gizli Şifre';

  @override
  String get newDataAccess => 'Yeni Veri Erişimi';

  @override
  String get lockToVault => 'Kasaya Kilitle';

  @override
  String get securityProtocol => 'Güvenlik Protokolü';

  @override
  String get cryptoLevel => 'Kripto Düzeyi!';

  @override
  String get veryWeak => 'Zayıf';

  @override
  String get weak => 'Orta';

  @override
  String get secure => 'Güçlü';

  @override
  String get onboardingTitle1 => 'Dijital Dünyanızı Güvenceye Alın';

  @override
  String get onboardingDesc1 =>
      'Tüm şifrelerinizi tek bir şifreli kasada güvenle saklayın.';

  @override
  String get onboardingTitle2 => 'Her Yerden Erişim';

  @override
  String get onboardingDesc2 =>
      'Cihazlarınız arasında güvenli ve kesintisiz senkronizasyon.';

  @override
  String get onboardingTitle3 => 'Biyometrik Giriş';

  @override
  String get onboardingDesc3 =>
      'Kasanızı parmak izi veya yüz tanıma ile anında açın.';

  @override
  String get vaultyReady => 'Güvenli Alan Hazır';

  @override
  String get terminalAccessReady => 'Terminal Erişimi Hazır';

  @override
  String get startSystem => 'Sistemi Başlat';

  @override
  String get emailVerificationSent => 'Doğrulama e-postası gönderildi.';

  @override
  String get errorPrefix => 'Hata: ';

  @override
  String get getStarted => 'Başlayalım';

  @override
  String get skip => 'Atla';

  @override
  String get loginFailed => 'Giriş Başarısız: ';

  @override
  String get biometricError => 'Doğrulama başarısız veya iptal edildi.';

  @override
  String get emailSentTitle => 'Onay Maili Gönderildi!';

  @override
  String get checkSpam => 'Lütfen e-posta kutunu (spam dahil) kontrol et.';

  @override
  String get resend => 'Tekrar Gönder';

  @override
  String get cancelAndLogout => 'Vazgeç ve Çıkış Yap';

  @override
  String get designedBy => 'Vaulty Ekibi Tarafından Tasarlandı';

  @override
  String get defaultUser => 'Kullanıcı';

  @override
  String get passwordConstraintError =>
      'Şifre en az 8 karakter olmalı; büyük harf, küçük harf, rakam ve sembol içermelidir.';
}
