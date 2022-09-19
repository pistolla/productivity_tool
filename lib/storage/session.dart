import 'dart:convert';

import 'package:remotesurveyadmin/storage/preference_storage.dart';
import 'package:remotesurveyadmin/storage/storage_keys.dart';
import 'package:remotesurveyadmin/storage/token_storage.dart';

class Session {
  late PrefStorage prefs;
  late TokenStorage tokens;

  set prefStorage(PrefStorage value) {
    prefs = value;
  }

  set tokenStorage(TokenStorage tokenStorage) {
    tokens = tokenStorage;
  }

  Session init({required PrefStorage pref, required TokenStorage token}) {
    Session().prefs = pref;
    Session().tokens = token;
    return Session();
  }

  Future<bool> getIsFirstLaunch() async {
    final bool? isFirstLaunch = await prefs.getBool(
      key: StorageKeys.firstLaunch,
    );
    return isFirstLaunch ?? true;
  }

  Future storeIsFirstLaunch({
    required bool isFirstLaunch,
  }) async {
    return prefs.putBool(
      key: StorageKeys.firstLaunch,
      value: isFirstLaunch,
    );
  }

  Future<String> getUserID() async {
    final String? userId = await prefs.getString(
      key: StorageKeys.userID,
    );
    return userId ?? "";
  }

  Future storeUserID({
    required String userID,
  }) async {
    if (userID.isEmpty) {
      return Future.delayed(Duration.zero);
    }
    return prefs.putString(
      key: StorageKeys.userID,
      value: userID,
    );
  }

  static Session? _instance;

  Session._internal() {
    _instance = this;
  }

  factory Session() => _instance ?? Session._internal();

  Future storeUsername({required String userName}) {
    return prefs.putString(
      key: StorageKeys.userNAME,
      value: userName,
    );
  }

  Future storeUserphone({required String userPhone}) {
    return prefs.putString(
      key: StorageKeys.userPHONE,
      value: userPhone,
    );
  }

  Future<String> getUserphone() async {
    final String? user = await prefs.getString(
      key: StorageKeys.userPHONE,
    );
    return user ?? "";
  }

  Future<String> getUsername() async {
    final String? user = await prefs.getString(
      key: StorageKeys.userNAME,
    );
    return user ?? "";
  }

  Future storeBiometricLogin({required bool allow}) {
    return prefs.putBool(
      key: StorageKeys.SettingAllowBiometric,
      value: allow,
    );
  }

  Future<Map<String, dynamic>> getSettings() async {
    final String? values = await prefs.getString(
      key: StorageKeys.Settings,
    );
    return json.decode(values ?? "{}");
  }

  Future storeSettings({required Map<String, dynamic> values}) {
    String encodeMap = json.encode(values);
    return prefs.putString(
      key: StorageKeys.Settings,
      value: encodeMap,
    );
  }

  void storeCredentials({required String username, required String password}) {
    tokens.storeUsername(username).then((value) => {
          tokens.storePassword(password).then((value) => print("Remember You"))
        });
  }
}
