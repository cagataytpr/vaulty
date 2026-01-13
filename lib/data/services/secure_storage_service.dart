import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // Singleton instance
  static final SecureStorageService _instance = SecureStorageService._internal();

  factory SecureStorageService() {
    return _instance;
  }

  SecureStorageService._internal();

  // Storage instance with configuration
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

  // --- Generic Methods ---

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // --- Master Key Specific Methods ---

  Future<void> storeMasterKey(String masterKey) async {
    await write(_kMasterKey, masterKey);
  }

  Future<String?> getMasterKey() async {
    return await read(_kMasterKey);
  }

  Future<void> clearMasterKey() async {
    await delete(_kMasterKey);
  }
}
