// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Vaulty';

  @override
  String get login => 'Anmelden';

  @override
  String get register => 'Registrieren';

  @override
  String get email => 'E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get dontHaveAccount => 'Kein Konto?';

  @override
  String get emailNotVerified =>
      'E-Mail nicht bestätigt. Bitte überprüfen Sie Ihren Posteingang.';

  @override
  String get unlockBiometric => 'Tresor entsperren';

  @override
  String get signOut => 'Abmelden';

  @override
  String get securityReportTitle => 'SICHERHEITSANALYSE-BERICHT';

  @override
  String securityRiskFound(int count) {
    return '$count Sicherheitsrisiken gefunden. Zum Überprüfen tippen.';
  }

  @override
  String get securityNoRisks =>
      'Gut gemacht! Alle Ihre Passwörter sind sicher.';

  @override
  String get riskWeak => 'Passwort ist zu kurz (Schwach)';

  @override
  String get riskReused =>
      'Dieses Passwort wird für ein anderes Konto wiederverwendet';

  @override
  String get secureSession => 'SICHERE SITZUNG';

  @override
  String get preferences => 'EINSTELLUNGEN';

  @override
  String get system => 'SYSTEM';

  @override
  String get about => 'Über Vaulty';

  @override
  String get settings => 'Einstellungen';

  @override
  String get searchPlaceholder => 'In Ihrem Tresor suchen...';

  @override
  String get emptyVault => 'Ihr Tresor ist derzeit leer.';

  @override
  String get emptyVaultSub =>
      'Fügen Sie Ihr erstes Passwort hinzu, um zu beginnen.';

  @override
  String get welcomeBack => 'Willkommen zurück';

  @override
  String get myVault => 'Mein Tresor';

  @override
  String get addPassword => 'Passwort hinzufügen';

  @override
  String get darkMode => 'Dunkelmodus';

  @override
  String get language => 'Sprache';

  @override
  String get exportPdf => 'Als PDF exportieren';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get save => 'Speichern';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get copySuccess =>
      'In die Zwischenablage kopiert! Wird in 45s gelöscht.';

  @override
  String get deleteConfirmation =>
      'Sind Sie sicher, dass Sie dieses Passwort löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get biometricReason =>
      'Bitte authentifizieren Sie sich, um fortzufahren';

  @override
  String get biometricUnlock => 'Mit Biometrie entsperren';

  @override
  String get errorGeneric => 'Etwas ist schief gelaufen.';

  @override
  String get loading => 'Laden...';

  @override
  String get version => 'Version';

  @override
  String get noPasswords => 'Keine Passwörter zum Exportieren.';

  @override
  String get alreadyHaveAccount => 'Haben Sie bereits ein Konto?';

  @override
  String get fullName => 'Vollständiger Name';

  @override
  String get passwordsDoNotMatch => 'Passwörter stimmen nicht überein';

  @override
  String get passwordResetSent =>
      'Link zum Zurücksetzen des Passworts an Ihre E-Mail gesendet.';

  @override
  String get pleaseEnterEmail => 'Bitte geben Sie zuerst Ihre E-Mail ein.';

  @override
  String get registerSuccess =>
      'Registrierung erfolgreich! Bitte bestätigen Sie Ihre E-Mail und melden Sie sich an.';

  @override
  String get createAccess => 'Zugang erstellen';

  @override
  String get newAccess => 'Neuer Zugang';

  @override
  String get registerTerminalTitle =>
      'Registrieren Sie sich beim Vaulty Terminal';

  @override
  String get generatePassword => 'Passwort generieren';

  @override
  String get copyPassword => 'Passwort kopieren';

  @override
  String get length => 'Länge';

  @override
  String get includeNumbers => 'Zahlen einschließen';

  @override
  String get includeSymbols => 'Symbole einschließen';

  @override
  String get includeUppercase => 'Großbuchstaben einschließen';

  @override
  String get copied => 'Kopiert!';

  @override
  String get securityParameters => 'Sicherheitsparameter';

  @override
  String get websiteName => 'Name der Website / App';

  @override
  String get secretPassword => 'Geheimes Passwort';

  @override
  String get newDataAccess => 'Neuer Datenzugang';

  @override
  String get lockToVault => 'Im Tresor sperren';

  @override
  String get securityProtocol => 'Sicherheitsprotokoll';

  @override
  String get cryptoLevel => 'Krypto-Level!';

  @override
  String get veryWeak => 'Sehr schwach';

  @override
  String get weak => 'Schwach';

  @override
  String get secure => 'Sicher';

  @override
  String get onboardingTitle1 => 'Sichern Sie Ihr digitales Leben';

  @override
  String get onboardingDesc1 =>
      'Bewahren Sie alle Ihre Passwörter sicher in einem verschlüsselten Tresor auf.';

  @override
  String get onboardingTitle2 => 'Zugriff von überall';

  @override
  String get onboardingDesc2 =>
      'Synchronisieren Sie sicher und nahtlos über Geräte hinweg.';

  @override
  String get onboardingTitle3 => 'Biometrischer Zugang';

  @override
  String get onboardingDesc3 =>
      'Entsperren Sie Ihren Tresor mit Ihrem Fingerabdruck oder Face ID.';

  @override
  String get vaultyReady => 'Sicherer Raum bereit';

  @override
  String get terminalAccessReady => 'Terminalzugriff bereit';

  @override
  String get startSystem => 'System starten';

  @override
  String get emailVerificationSent => 'Bestätigungs-E-Mail gesendet.';

  @override
  String get errorPrefix => 'Fehler: ';

  @override
  String get getStarted => 'Loslegen';

  @override
  String get skip => 'Überspringen';

  @override
  String get loginFailed => 'Anmeldung fehlgeschlagen: ';

  @override
  String get biometricError =>
      'Authentifizierung fehlgeschlagen oder abgebrochen.';

  @override
  String get emailSentTitle => 'Bestätigungs-E-Mail gesendet!';

  @override
  String get checkSpam =>
      'Bitte überprüfen Sie Ihren Posteingang (einschließlich Spam).';

  @override
  String get resend => 'Erneut senden';

  @override
  String get cancelAndLogout => 'Abbrechen und abmelden';

  @override
  String get designedBy => 'Entworfen vom Vaulty Team';

  @override
  String get defaultUser => 'Benutzer';

  @override
  String get passwordConstraintError =>
      'Das Passwort muss mindestens 8 Zeichen lang sein und Großbuchstaben, Kleinbuchstaben, Zahlen und Symbole enthalten.';
}
