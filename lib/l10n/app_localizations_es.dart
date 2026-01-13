// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Vaulty';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get register => 'Registrarse';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get dontHaveAccount => '¿No tienes una cuenta?';

  @override
  String get emailNotVerified =>
      'Correo electrónico no verificado. Por favor revise su bandeja de entrada.';

  @override
  String get unlockBiometric => 'Desbloquear Bóveda';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get securityReportTitle => 'INFORME DE ANÁLISIS DE SEGURIDAD';

  @override
  String securityRiskFound(int count) {
    return '$count riesgos de seguridad encontrados. Toque para revisar.';
  }

  @override
  String get securityNoRisks =>
      '¡Buen trabajo! Todas tus contraseñas son seguras.';

  @override
  String get riskWeak => 'La contraseña es demasiado corta (Débil)';

  @override
  String get riskReused => 'Esta contraseña se reutiliza en otra cuenta';

  @override
  String get secureSession => 'SESIÓN SEGURA';

  @override
  String get preferences => 'PREFERENCIAS';

  @override
  String get system => 'SISTEMA';

  @override
  String get about => 'Acerca de Vaulty';

  @override
  String get settings => 'Ajustes';

  @override
  String get searchPlaceholder => 'Buscar en tu bóveda...';

  @override
  String get emptyVault => 'Tu bóveda está tranquila en este momento.';

  @override
  String get emptyVaultSub => 'Agrega tu primera contraseña para comenzar.';

  @override
  String get welcomeBack => 'Bienvenido de nuevo';

  @override
  String get myVault => 'Mi Bóveda';

  @override
  String get addPassword => 'Añadir contraseña';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get exportPdf => 'Exportar como PDF';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get save => 'Guardar';

  @override
  String get edit => 'Editar';

  @override
  String get copySuccess => '¡Copiado al portapapeles! Se borrará en 45s.';

  @override
  String get deleteConfirmation =>
      '¿Estás seguro de que quieres eliminar esta contraseña? Esta acción no se puede deshacer.';

  @override
  String get biometricReason => 'Por favor autentíquese para continuar';

  @override
  String get biometricUnlock => 'Desbloquear con biometría';

  @override
  String get errorGeneric => 'Algo salió mal.';

  @override
  String get loading => 'Cargando...';

  @override
  String get version => 'Versión';

  @override
  String get noPasswords => 'No hay contraseñas para exportar.';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta?';

  @override
  String get fullName => 'Nombre completo';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get passwordResetSent =>
      'Enlace de restablecimiento de contraseña enviado a su correo electrónico.';

  @override
  String get pleaseEnterEmail =>
      'Por favor ingrese su correo electrónico primero.';

  @override
  String get registerSuccess =>
      '¡Registro exitoso! Por favor verifique su correo electrónico e inicie sesión.';

  @override
  String get createAccess => 'Crear Acceso';

  @override
  String get newAccess => 'Nuevo Acceso';

  @override
  String get registerTerminalTitle => 'Registrarse en Vaulty Terminal';

  @override
  String get generatePassword => 'Generar contraseña';

  @override
  String get copyPassword => 'Copiar contraseña';

  @override
  String get length => 'Longitud';

  @override
  String get includeNumbers => 'Incluir números';

  @override
  String get includeSymbols => 'Incluir símbolos';

  @override
  String get includeUppercase => 'Incluir mayúsculas';

  @override
  String get copied => '¡Copiado!';

  @override
  String get securityParameters => 'Parámetros de seguridad';

  @override
  String get websiteName => 'Nombre del sitio web / aplicación';

  @override
  String get secretPassword => 'Contraseña secreta';

  @override
  String get newDataAccess => 'Nuevo acceso a datos';

  @override
  String get lockToVault => 'Bloquear en la bóveda';

  @override
  String get securityProtocol => 'Protocolo de seguridad';

  @override
  String get cryptoLevel => '¡Nivel de criptografía!';

  @override
  String get veryWeak => 'Muy débil';

  @override
  String get weak => 'Débil';

  @override
  String get secure => 'Segura';

  @override
  String get onboardingTitle1 => 'Asegura tu vida digital';

  @override
  String get onboardingDesc1 =>
      'Mantenga todas sus contraseñas seguras en una bóveda encriptada.';

  @override
  String get onboardingTitle2 => 'Acceso desde cualquier lugar';

  @override
  String get onboardingDesc2 =>
      'Sincronice entre dispositivos de forma segura y sin problemas.';

  @override
  String get onboardingTitle3 => 'Acceso biométrico';

  @override
  String get onboardingDesc3 =>
      'Desbloquee su bóveda con su huella digital o Face ID.';

  @override
  String get vaultyReady => 'Espacio seguro listo';

  @override
  String get terminalAccessReady => 'Acceso a terminal listo';

  @override
  String get startSystem => 'Iniciar sistema';

  @override
  String get emailVerificationSent =>
      'Correo electrónico de verificación enviado.';

  @override
  String get errorPrefix => 'Error: ';

  @override
  String get getStarted => 'Empezar';

  @override
  String get skip => 'Saltar';

  @override
  String get loginFailed => 'Inicio de sesión fallido: ';

  @override
  String get biometricError => 'Autenticación fallida o cancelada.';

  @override
  String get emailSentTitle => '¡Correo electrónico de verificación enviado!';

  @override
  String get checkSpam =>
      'Por favor revise su bandeja de entrada (incluido spam).';

  @override
  String get resend => 'Reenviar';

  @override
  String get cancelAndLogout => 'Cancelar y cerrar sesión';

  @override
  String get designedBy => 'Diseñado por Vaulty Team';

  @override
  String get defaultUser => 'Usuario';

  @override
  String get passwordConstraintError =>
      'La contraseña debe tener al menos 8 caracteres e incluir mayúsculas, minúsculas, números y símbolos.';
}
