import 'package:remotesurveyadmin/storage/secure_storage.dart';
import 'package:remotesurveyadmin/storage/storage_keys.dart';

class TokenStorage {
  final SecureStorage secureStorage;

  TokenStorage({
    required this.secureStorage,
  });

  Future<void> storeAccessToken(String accessToken) {
    return secureStorage.putString(
      key: StorageKeys.accessToken,
      value: accessToken,
    );
  }

  Future<String?> getAccessToken() {
    return secureStorage.getString(
      key: StorageKeys.accessToken,
    );
  }

  Future<void> storeUsername(String username) {
    return secureStorage.putString(
      key: StorageKeys.SettingUsername,
      value: username,
    );
  }

  Future<String?> getUsername() {
    return secureStorage.getString(
      key: StorageKeys.SettingUsername,
    );
  }

  Future<void> storePassword(String password) {
    return secureStorage.putString(
      key: StorageKeys.SettingPassword,
      value: password,
    );
  }

  Future<String?> getPassword() {
    return secureStorage.getString(
      key: StorageKeys.SettingPassword,
    );
  }

  Future<bool> hasToken() async {
    final String? accessToken = await getAccessToken();
    return accessToken != null;
  }

  Future<void> removeAccessToken() {
    return secureStorage.remove(
      key: StorageKeys.accessToken,
    );
  }

  Future<void> clear() {
    return Future.wait([
      removeAccessToken(),
    ]);
  }
}
