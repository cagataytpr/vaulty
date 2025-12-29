import 'package:local_auth/local_auth.dart';

class AuthService {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> authenticate() async {
    try {
      // Cihazın biyometrik kapasitesini kontrol et
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

      if (!canAuthenticate) return false;

      // EN GÜNCEL VE HATASIZ YÖNTEM:
      return await _auth.authenticate(
        localizedReason: 'Şifrelerinize erişmek için lütfen kimliğinizi doğrulayın',
        // Eğer 'options' hata veriyorsa, AuthenticationOptions'ı paketin içinden tam çağıralım
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } catch (e) {
      print("Hata oluştu: $e");
      return false;
    }
  }
}