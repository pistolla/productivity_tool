import 'package:remotesurveyadmin/config/constants.dart';

abstract class StorageKeys {
  const StorageKeys._();

  static const String firstLaunch = 'key-first-launch';
  static const String accessToken = 'key-access-token';
  static const String userID = 'key-user-XX';
  static const String userNAME = 'key-user-name';
  static const String userPHONE = 'key-user-phone';
  static const String SettingUsername = 'key-username';
  static const String SettingPassword = 'key-userpass';
  static const String SettingAllowBiometric = 'key-setting-bio';
  static const String Settings = 'key-settings';
  static const String SettingEnv = 'key-setting-env';
  static const String SettingLang = 'key-setting-lang';
  static const String SettingRememberMe = 'key-setting-remember-me';
  static const String SettingOffline = 'key-setting-offline';
  static const String SettingNotifications = 'key-setting-notify';
  static const String SettingCurrency = 'key-setting-currency';
  static const String SettingFirstDay = 'key-setting-first-day';
  static const String SettingNotificationSound =
      'key-setting-notification-sound';
  static const String SettingDateFormat = 'key-setting-date-format';
  static const String SettingTimezone = 'key-setting-time-zone';
  static const String SettingWaterUnitPrice = 'key-setting-water-unit';
  static const String SettingElectricityUnitPrice = 'key-setting-electricity-unit';
  static const String SettingGasUnitPrice = 'key-setting-gas-unit';
  static const String SettingShowHelp = 'key-setting-show-help';

  static const defaultSettings = {
    SettingEnv: "PROD",
    SettingAllowBiometric: false,
    SettingLang: "English",
    SettingRememberMe: true,
    SettingOffline: false,
    SettingNotifications: true,
    SettingCurrency: "KES",
    SettingNotificationSound: "default",
    SettingDateFormat: "dd/MM/yyyy",
    SettingTimezone: "Eastern Africa Time (EAT)",
    SettingFirstDay: DateTime.monday,
    SettingWaterUnitPrice: h20UnitPrice,
    SettingElectricityUnitPrice: powerUnitPrice,
    SettingGasUnitPrice: gasUnitPrice,
    SettingShowHelp: false,
  };
}
