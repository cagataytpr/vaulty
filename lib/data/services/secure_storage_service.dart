import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // Singleton instance
  static final SecureStorageService _instance = SecureStorageService._internal();

  factory SecureStorageService() {
    return _instance;
  }

  SecureStorageService._internal();

  /// Güvenli depolama yapılandırması.
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  // Keys
  static const String _kMasterKey = 'vaulty_master_key';

  // --- Genel Metotlar ---

  /// Belirtilen anahtar-değer çiftini güvenli alana yazar.
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Belirtilen anahtara ait değeri okur.
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// Belirtilen anahtarı siler.
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Tüm güvenli depolama alanını temizler.
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // --- Master Key Metotları ---

  /// Master anahtarı güvenli alana kaydeder.
  Future<void> storeMasterKey(String masterKey) async {
    await write(_kMasterKey, masterKey);
  }

  /// Kayıtlı master anahtarı döndürür.
  Future<String?> getMasterKey() async {
    return await read(_kMasterKey);
  }

  /// Master anahtarı siler.
  Future<void> clearMasterKey() async {
    await delete(_kMasterKey);
  }
}
