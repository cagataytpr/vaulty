// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Vaulty';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get emailNotVerified => 'Email not verified. Please check your inbox.';

  @override
  String get unlockBiometric => 'Unlock Vault';

  @override
  String get signOut => 'Sign Out';

  @override
  String get securityReportTitle => 'SECURITY ANALYSIS REPORT';

  @override
  String securityRiskFound(int count) {
    return '$count security risks found. Tap to review.';
  }

  @override
  String get securityNoRisks => 'Great job! All your passwords are secure.';

  @override
  String get riskWeak => 'Password is too short (Weak)';

  @override
  String get riskReused => 'This password is reused on another account';

  @override
  String get secureSession => 'SECURE SESSION';

  @override
  String get preferences => 'PREFERENCES';

  @override
  String get system => 'SYSTEM';

  @override
  String get about => 'About Vaulty';

  @override
  String get settings => 'Settings';

  @override
  String get searchPlaceholder => 'Search in your vault...';

  @override
  String get emptyVault => 'Your vault is quiet right now.';

  @override
  String get emptyVaultSub => 'Add your first password to start.';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get myVault => 'My Vault';

  @override
  String get addPassword => 'Add Password';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get exportPdf => 'Export as PDF';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get copySuccess => 'Copied to clipboard! Will be cleared in 45s.';

  @override
  String get deleteConfirmation =>
      'Are you sure you want to delete this password? This action cannot be undone.';

  @override
  String get biometricReason => 'Please authenticate to proceed';

  @override
  String get biometricUnlock => 'Unlock with Biometrics';

  @override
  String get errorGeneric => 'Something went wrong.';

  @override
  String get loading => 'Loading...';

  @override
  String get version => 'Version';

  @override
  String get noPasswords => 'No passwords to export.';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get fullName => 'Full Name';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get passwordResetSent => 'Password reset link sent to your email.';

  @override
  String get pleaseEnterEmail => 'Please enter your email first.';

  @override
  String get registerSuccess =>
      'Registration successful! Please verify your email and login.';

  @override
  String get createAccess => 'Create Access';

  @override
  String get newAccess => 'New Access';

  @override
  String get registerTerminalTitle => 'Register to Vaulty Terminal';

  @override
  String get generatePassword => 'Generate Password';

  @override
  String get copyPassword => 'Copy Password';

  @override
  String get length => 'Length';

  @override
  String get includeNumbers => 'Include Numbers';

  @override
  String get includeSymbols => 'Include Symbols';

  @override
  String get includeUppercase => 'Include Uppercase';

  @override
  String get copied => 'Copied!';

  @override
  String get securityParameters => 'Security Parameters';

  @override
  String get websiteName => 'Website / App Name';

  @override
  String get secretPassword => 'Secret Password';

  @override
  String get newDataAccess => 'New Data Access';

  @override
  String get lockToVault => 'Lock to Vault';

  @override
  String get securityProtocol => 'Security Protocol';

  @override
  String get cryptoLevel => 'Crypto Level!';

  @override
  String get veryWeak => 'Very Weak';

  @override
  String get weak => 'Weak';

  @override
  String get secure => 'Secure';

  @override
  String get onboardingTitle1 => 'Secure Your Digital Life';

  @override
  String get onboardingDesc1 =>
      'Keep all your passwords safe in one encrypted vault.';

  @override
  String get onboardingTitle2 => 'Access Anywhere';

  @override
  String get onboardingDesc2 => 'Sync across devices securely and seamlessly.';

  @override
  String get onboardingTitle3 => 'Biometric Access';

  @override
  String get onboardingDesc3 =>
      'Unlock your vault with your fingerprint or face ID.';

  @override
  String get vaultyReady => 'Secure Space Ready';

  @override
  String get terminalAccessReady => 'Terminal Access Ready';

  @override
  String get startSystem => 'Start System';

  @override
  String get emailVerificationSent => 'Verification email sent.';

  @override
  String get errorPrefix => 'Error: ';

  @override
  String get getStarted => 'Get Started';

  @override
  String get skip => 'Skip';

  @override
  String get loginFailed => 'Login Failed: ';

  @override
  String get biometricError => 'Authentication failed or canceled.';

  @override
  String get emailSentTitle => 'Verification Email Sent!';

  @override
  String get checkSpam => 'Please check your inbox (including spam).';

  @override
  String get resend => 'Resend';

  @override
  String get cancelAndLogout => 'Cancel and Log Out';

  @override
  String get designedBy => 'Designed by Vaulty Team';

  @override
  String get defaultUser => 'User';

  @override
  String get passwordConstraintError =>
      'Password must be at least 8 characters long and include uppercase, lowercase, number, and symbol.';
}
