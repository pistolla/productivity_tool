abstract class GlobalEvent {}

class SessionEnded extends GlobalEvent {}

class SessionStarted extends GlobalEvent {}

class SessionUpdated extends GlobalEvent {
  bool isFirstLaunch;

  String userid;

  String token;

  SessionUpdated(
      {required this.isFirstLaunch, required this.userid, required this.token});
}

class SettingChanged extends GlobalEvent {
  late Map<String, dynamic> settings;

  SettingChanged({required this.settings});
}

class ViewChanged extends GlobalEvent {
  late int view;

  ViewChanged({required this.view});
}

class NotificationReceived extends GlobalEvent {
  late int note;

  NotificationReceived({required this.note});
}
