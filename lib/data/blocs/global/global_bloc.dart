import 'package:remotesurveyadmin/api/response_data.dart';
import 'package:remotesurveyadmin/data/blocs/global/global_event.dart';
import 'package:remotesurveyadmin/data/blocs/global/global_state.dart';
import 'package:remotesurveyadmin/data/repository/user_repository.dart';
import 'package:remotesurveyadmin/models/user_model.dart';
import 'package:remotesurveyadmin/storage/session.dart';
import 'package:remotesurveyadmin/storage/storage_keys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  final Session session;
  final UserRepository userRepository;

  GlobalBloc({required this.session, required this.userRepository})
      : super(GlobalInitialState(firstLaunch: false));

  Future<ResponseData<UserModel>> fetchUser() {
    String token = state.token;
    String userid = state.userid;
    return userRepository.me({
      "api": {"request": "viewProfile", "token": token, "user": userid},
      "input": {"profile": ""}
    });
  }

  Future<ResponseData> autoLoginUser() async {
    String? email = await session.tokens.getUsername();
    String? password = await session.tokens.getPassword();
    return userRepository.authenticateUser({
      "api": {"request": "login", "token": "0", "user": 0},
      "input": {"phone": email!, "password": password!}
    });
  }

  @override
  Stream<GlobalState> mapEventToState(GlobalEvent event) async* {
    String myId = "";
    String myToken = "";
    bool fLaunch = false;
    Map<String, dynamic> parameters = {};
    if (event is SessionStarted) {
      await Future.wait([
        session.getIsFirstLaunch().then((value) => fLaunch = value),
        session.tokens.getAccessToken().then((toke) => myToken = toke ?? ""),
        session.getUserID().then((userid) => myId = userid),
        session.getSettings().then((value) => {
              if (value.isEmpty)
                {
                  session.storeSettings(values: StorageKeys.defaultSettings),
                  parameters = StorageKeys.defaultSettings
                }
              else
                {parameters = value}
            })
      ]);
      yield GlobalInitialState(firstLaunch: fLaunch);
      if (myId.isNotEmpty && myToken.isNotEmpty) {
        yield GlobalActiveState(parameters, {},
            userid: myId,
            token: myToken,
            showSplash: fLaunch,
            showOverlay: parameters[StorageKeys.SettingShowHelp],
            viewType: state.viewType,
            notification: state.notifications);
      }
    } else if (event is SessionUpdated) {
      yield GlobalActiveState(state.settings, {},
          userid: event.userid,
          token: event.token,
          showSplash: event.isFirstLaunch,
          showOverlay: state.settings[StorageKeys.SettingShowHelp],
          viewType: state.viewType,
          notification: state.notifications);
      await session
          .storeIsFirstLaunch(isFirstLaunch: event.isFirstLaunch)
          .then((x) => {
                session.tokens.storeAccessToken(event.token).then((y) => {
                      if (event.userid.isNotEmpty)
                        {
                          session
                              .storeUserID(userID: event.userid)
                              .then((value) => {})
                              .whenComplete(() => {print("SESSION PERSISTED")})
                        }
                    })
              });
    } else if (event is SessionEnded) {
      {
        session.tokens.storeAccessToken("");
        yield GlobalInitialState(firstLaunch: false);
      }
    } else if (event is SettingChanged) {
      yield GlobalActiveState(state.settings, event.settings,
          userid: state.userid,
          token: state.token,
          showSplash: state.showSplash,
          showOverlay: event.settings[StorageKeys.SettingShowHelp],
          viewType: state.viewType,
          notification: state.notifications);
      if (state.settings.length == StorageKeys.defaultSettings.length) {
        session
            .storeSettings(values: state.settings)
            .then((value) => {})
            .whenComplete(() => {print("SETTINGS PERSISTED")});
      }
    } else if (event is ViewChanged) {
      yield GlobalActiveState(state.settings, {},
          userid: state.userid,
          token: state.token,
          showSplash: state.showSplash,
          showOverlay: state.showOverlay,
          viewType: event.view,
          notification: state.notifications);
    } else if (event is NotificationReceived) {
      yield GlobalActiveState(state.settings, {},
          userid: state.userid,
          token: state.token,
          showSplash: state.showSplash,
          showOverlay: state.showOverlay,
          viewType: state.viewType,
          notification: event.note);
    }
  }
}
