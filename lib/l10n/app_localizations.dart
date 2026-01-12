import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Vaulty'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @emailNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Email not verified. Please check your inbox.'**
  String get emailNotVerified;

  /// No description provided for @unlockBiometric.
  ///
  /// In en, this message translates to:
  /// **'Unlock Vault'**
  String get unlockBiometric;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @securityReportTitle.
  ///
  /// In en, this message translates to:
  /// **'SECURITY ANALYSIS REPORT'**
  String get securityReportTitle;

  /// No description provided for @securityRiskFound.
  ///
  /// In en, this message translates to:
  /// **'{count} security risks found. Tap to review.'**
  String securityRiskFound(int count);

  /// No description provided for @securityNoRisks.
  ///
  /// In en, this message translates to:
  /// **'Great job! All your passwords are secure.'**
  String get securityNoRisks;

  /// No description provided for @riskWeak.
  ///
  /// In en, this message translates to:
  /// **'Password is too short (Weak)'**
  String get riskWeak;

  /// No description provided for @riskReused.
  ///
  /// In en, this message translates to:
  /// **'This password is reused on another account'**
  String get riskReused;

  /// No description provided for @secureSession.
  ///
  /// In en, this message translates to:
  /// **'SECURE SESSION'**
  String get secureSession;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'PREFERENCES'**
  String get preferences;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'SYSTEM'**
  String get system;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About Vaulty'**
  String get about;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search in your vault...'**
  String get searchPlaceholder;

  /// No description provided for @emptyVault.
  ///
  /// In en, this message translates to:
  /// **'Your vault is quiet right now.'**
  String get emptyVault;

  /// No description provided for @emptyVaultSub.
  ///
  /// In en, this message translates to:
  /// **'Add your first password to start.'**
  String get emptyVaultSub;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @myVault.
  ///
  /// In en, this message translates to:
  /// **'My Vault'**
  String get myVault;

  /// No description provided for @addPassword.
  ///
  /// In en, this message translates to:
  /// **'Add Password'**
  String get addPassword;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export as PDF'**
  String get exportPdf;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @copySuccess.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard! Will be cleared in 45s.'**
  String get copySuccess;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this password? This action cannot be undone.'**
  String get deleteConfirmation;

  /// No description provided for @biometricReason.
  ///
  /// In en, this message translates to:
  /// **'Please authenticate to proceed'**
  String get biometricReason;

  /// No description provided for @biometricUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock with Biometrics'**
  String get biometricUnlock;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get errorGeneric;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @noPasswords.
  ///
  /// In en, this message translates to:
  /// **'No passwords to export.'**
  String get noPasswords;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordResetSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent to your email.'**
  String get passwordResetSent;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email first.'**
  String get pleaseEnterEmail;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful! Please verify your email and login.'**
  String get registerSuccess;

  /// No description provided for @createAccess.
  ///
  /// In en, this message translates to:
  /// **'Create Access'**
  String get createAccess;

  /// No description provided for @newAccess.
  ///
  /// In en, this message translates to:
  /// **'New Access'**
  String get newAccess;

  /// No description provided for @registerTerminalTitle.
  ///
  /// In en, this message translates to:
  /// **'Register to Vaulty Terminal'**
  String get registerTerminalTitle;

  /// No description provided for @generatePassword.
  ///
  /// In en, this message translates to:
  /// **'Generate Password'**
  String get generatePassword;

  /// No description provided for @copyPassword.
  ///
  /// In en, this message translates to:
  /// **'Copy Password'**
  String get copyPassword;

  /// No description provided for @length.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get length;

  /// No description provided for @includeNumbers.
  ///
  /// In en, this message translates to:
  /// **'Include Numbers'**
  String get includeNumbers;

  /// No description provided for @includeSymbols.
  ///
  /// In en, this message translates to:
  /// **'Include Symbols'**
  String get includeSymbols;

  /// No description provided for @includeUppercase.
  ///
  /// In en, this message translates to:
  /// **'Include Uppercase'**
  String get includeUppercase;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied!'**
  String get copied;

  /// No description provided for @securityParameters.
  ///
  /// In en, this message translates to:
  /// **'Security Parameters'**
  String get securityParameters;

  /// No description provided for @websiteName.
  ///
  /// In en, this message translates to:
  /// **'Website / App Name'**
  String get websiteName;

  /// No description provided for @secretPassword.
  ///
  /// In en, this message translates to:
  /// **'Secret Password'**
  String get secretPassword;

  /// No description provided for @newDataAccess.
  ///
  /// In en, this message translates to:
  /// **'New Data Access'**
  String get newDataAccess;

  /// No description provided for @lockToVault.
  ///
  /// In en, this message translates to:
  /// **'Lock to Vault'**
  String get lockToVault;

  /// No description provided for @securityProtocol.
  ///
  /// In en, this message translates to:
  /// **'Security Protocol'**
  String get securityProtocol;

  /// No description provided for @cryptoLevel.
  ///
  /// In en, this message translates to:
  /// **'Crypto Level!'**
  String get cryptoLevel;

  /// No description provided for @veryWeak.
  ///
  /// In en, this message translates to:
  /// **'Very Weak'**
  String get veryWeak;

  /// No description provided for @weak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get weak;

  /// No description provided for @secure.
  ///
  /// In en, this message translates to:
  /// **'Secure'**
  String get secure;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Secure Your Digital Life'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Keep all your passwords safe in one encrypted vault.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Access Anywhere'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Sync across devices securely and seamlessly.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Biometric Access'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Unlock your vault with your fingerprint or face ID.'**
  String get onboardingDesc3;

  /// No description provided for @vaultyReady.
  ///
  /// In en, this message translates to:
  /// **'Secure Space Ready'**
  String get vaultyReady;

  /// No description provided for @terminalAccessReady.
  ///
  /// In en, this message translates to:
  /// **'Terminal Access Ready'**
  String get terminalAccessReady;

  /// No description provided for @startSystem.
  ///
  /// In en, this message translates to:
  /// **'Start System'**
  String get startSystem;

  /// No description provided for @emailVerificationSent.
  ///
  /// In en, this message translates to:
  /// **'Verification email sent.'**
  String get emailVerificationSent;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get errorPrefix;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login Failed: '**
  String get loginFailed;

  /// No description provided for @biometricError.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed or canceled.'**
  String get biometricError;

  /// No description provided for @emailSentTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification Email Sent!'**
  String get emailSentTitle;

  /// No description provided for @checkSpam.
  ///
  /// In en, this message translates to:
  /// **'Please check your inbox (including spam).'**
  String get checkSpam;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @cancelAndLogout.
  ///
  /// In en, this message translates to:
  /// **'Cancel and Log Out'**
  String get cancelAndLogout;

  /// No description provided for @designedBy.
  ///
  /// In en, this message translates to:
  /// **'Designed by Vaulty Team'**
  String get designedBy;

  /// No description provided for @defaultUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get defaultUser;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
