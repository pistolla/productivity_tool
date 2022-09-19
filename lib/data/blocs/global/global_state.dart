abstract class GlobalState {
  late Map<String, dynamic> settings = {};
  late bool showSplash;
  late String userid;
  late String token;
  late bool showOverlay;
  late int viewType = 0;
  late int notifications = 0;
}

class GlobalInitialState extends GlobalState {
  bool firstLaunch;

  GlobalInitialState({required this.firstLaunch});
}

class GlobalActiveState extends GlobalState {
  GlobalActiveState(
      Map<String, dynamic> current, Map<String, dynamic> parameters,
      {required bool showSplash,
      required String userid,
      required String token,
      required bool showOverlay,
      required int viewType,
      required int notification,
      }) {
    parameters.forEach((key, value) => current[key] = value);
    settings = current;
    this.showSplash = showSplash;
    this.userid = userid;
    this.token = token;
    this.showOverlay = showOverlay;
    this.viewType = viewType;
    this.notifications = notification;
  }
}

class GlobalInActiveState extends GlobalState {}
