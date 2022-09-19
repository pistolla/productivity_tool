import 'package:remotesurveyadmin/api/auth_service.dart';
import 'package:remotesurveyadmin/data/blocs/global/global_bloc.dart';
import 'package:remotesurveyadmin/data/blocs/global/global_event.dart';
import 'package:remotesurveyadmin/data/repository/user_repository.dart';
import 'package:remotesurveyadmin/routes.dart';
import 'package:remotesurveyadmin/config/theme.dart';
import 'package:remotesurveyadmin/storage/preference_storage.dart';
import 'package:remotesurveyadmin/storage/secure_storage.dart';
import 'package:remotesurveyadmin/storage/session.dart';
import 'package:remotesurveyadmin/storage/token_storage.dart';
import 'package:remotesurveyadmin/views/welcome/welcome_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'firebase_options.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print(error);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
  print(message.data.toString());
  print(message.notification!.title);
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> main() async {
  // BlocObserver observer = SimpleBlocObserver();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.instance.getToken().then((value) {
    String? token = value;
    debugPrint("FCMTOKEN: $token");
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'PUSH_NOTIFICATIONS_CHANNEL', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    Session session = Session();
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data != null) {
            SharedPreferences? preferences =
                snapshot.data as SharedPreferences?;
            UserRepository _repository =
                UserRepository(userResource: AuthService());
            return BlocProvider(
              create: (context) => GlobalBloc(
                  userRepository: _repository,
                  session: session.init(
                      pref: PrefStorage(sharedPref: preferences),
                      token: TokenStorage(
                          secureStorage: SecureStorage(
                              flutterSecureStorage:
                                  const FlutterSecureStorage())))),
              child: MaterialApp(
                title: 'remotesurveyadmin',
                theme: theme(),
                routes: routes,
                initialRoute: WelcomeView.routeName,
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
