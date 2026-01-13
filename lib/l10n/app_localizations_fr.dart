// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Vaulty';

  @override
  String get login => 'Connexion';

  @override
  String get register => 'S\'inscrire';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get dontHaveAccount => 'Pas de compte ?';

  @override
  String get emailNotVerified =>
      'E-mail non vérifié. Veuillez vérifier votre boîte de réception.';

  @override
  String get unlockBiometric => 'Déverrouiller le coffre';

  @override
  String get signOut => 'Déconnexion';

  @override
  String get securityReportTitle => 'RAPPORT D\'ANALYSE DE SÉCURITÉ';

  @override
  String securityRiskFound(int count) {
    return '$count risques de sécurité trouvés. Appuyez pour examiner.';
  }

  @override
  String get securityNoRisks =>
      'Excellent travail ! Tous vos mots de passe sont sécurisés.';

  @override
  String get riskWeak => 'Le mot de passe est trop court (Faible)';

  @override
  String get riskReused => 'Ce mot de passe est réutilisé sur un autre compte';

  @override
  String get secureSession => 'SESSION SÉCURISÉE';

  @override
  String get preferences => 'PRÉFÉRENCES';

  @override
  String get system => 'SYSTÈME';

  @override
  String get about => 'À propos de Vaulty';

  @override
  String get settings => 'Paramètres';

  @override
  String get searchPlaceholder => 'Rechercher dans votre coffre...';

  @override
  String get emptyVault => 'Votre coffre est calme pour le moment.';

  @override
  String get emptyVaultSub =>
      'Ajoutez votre premier mot de passe pour commencer.';

  @override
  String get welcomeBack => 'Bon retour';

  @override
  String get myVault => 'Mon coffre';

  @override
  String get addPassword => 'Ajouter un mot de passe';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get language => 'Langue';

  @override
  String get exportPdf => 'Exporter en PDF';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get save => 'Enregistrer';

  @override
  String get edit => 'Modifier';

  @override
  String get copySuccess =>
      'Copié dans le presse-papiers ! Sera effacé dans 45s.';

  @override
  String get deleteConfirmation =>
      'Êtes-vous sûr de vouloir supprimer ce mot de passe ? Cette action est irréversible.';

  @override
  String get biometricReason => 'Veuillez vous authentifier pour continuer';

  @override
  String get biometricUnlock => 'Déverrouiller avec la biométrie';

  @override
  String get errorGeneric => 'Un problème est survenu.';

  @override
  String get loading => 'Chargement...';

  @override
  String get version => 'Version';

  @override
  String get noPasswords => 'Aucun mot de passe à exporter.';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ?';

  @override
  String get fullName => 'Nom complet';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get passwordResetSent =>
      'Lien de réinitialisation du mot de passe envoyé à votre e-mail.';

  @override
  String get pleaseEnterEmail => 'Veuillez d\'abord entrer votre e-mail.';

  @override
  String get registerSuccess =>
      'Inscription réussie ! Veuillez vérifier votre e-mail et vous connecter.';

  @override
  String get createAccess => 'Créer un accès';

  @override
  String get newAccess => 'Nouvel accès';

  @override
  String get registerTerminalTitle => 'S\'inscrire au terminal Vaulty';

  @override
  String get generatePassword => 'Générer un mot de passe';

  @override
  String get copyPassword => 'Copier le mot de passe';

  @override
  String get length => 'Longueur';

  @override
  String get includeNumbers => 'Inclure des chiffres';

  @override
  String get includeSymbols => 'Inclure des symboles';

  @override
  String get includeUppercase => 'Inclure des majuscules';

  @override
  String get copied => 'Copié !';

  @override
  String get securityParameters => 'Paramètres de sécurité';

  @override
  String get websiteName => 'Nom du site Web / de l\'application';

  @override
  String get secretPassword => 'Mot de passe secret';

  @override
  String get newDataAccess => 'Nouvel accès aux données';

  @override
  String get lockToVault => 'Verrouiller dans le coffre';

  @override
  String get securityProtocol => 'Protocole de sécurité';

  @override
  String get cryptoLevel => 'Niveau de crypto !';

  @override
  String get veryWeak => 'Très faible';

  @override
  String get weak => 'Faible';

  @override
  String get secure => 'Sécurisé';

  @override
  String get onboardingTitle1 => 'Sécurisez votre vie numérique';

  @override
  String get onboardingDesc1 =>
      'Gardez tous vos mots de passe en sécurité dans un coffre chiffré.';

  @override
  String get onboardingTitle2 => 'Accès partout';

  @override
  String get onboardingDesc2 =>
      'Synchronisez entre les appareils de manière sécurisée et transparente.';

  @override
  String get onboardingTitle3 => 'Accès biométrique';

  @override
  String get onboardingDesc3 =>
      'Déverrouillez votre coffre avec votre empreinte digitale ou Face ID.';

  @override
  String get vaultyReady => 'Espace sécurisé prêt';

  @override
  String get terminalAccessReady => 'Accès au terminal prêt';

  @override
  String get startSystem => 'Démarrer le système';

  @override
  String get emailVerificationSent => 'E-mail de vérification envoyé.';

  @override
  String get errorPrefix => 'Erreur : ';

  @override
  String get getStarted => 'Commencer';

  @override
  String get skip => 'Passer';

  @override
  String get loginFailed => 'Connexion échouée : ';

  @override
  String get biometricError => 'Authentification échouée ou annulée.';

  @override
  String get emailSentTitle => 'E-mail de vérification envoyé !';

  @override
  String get checkSpam =>
      'Veuillez vérifier votre boîte de réception (y compris les spams).';

  @override
  String get resend => 'Renvoyer';

  @override
  String get cancelAndLogout => 'Annuler et se déconnecter';

  @override
  String get designedBy => 'Conçu par l\'équipe Vaulty';

  @override
  String get defaultUser => 'Utilisateur';

  @override
  String get passwordConstraintError =>
      'Le mot de passe doit comporter au moins 8 caractères et inclure des majuscules, des minuscules, des chiffres et des symboles.';
}
