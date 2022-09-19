import 'package:firebase_core/firebase_core.dart';
import 'package:remotesurveyadmin/config/size_config.dart';
import 'package:remotesurveyadmin/data/blocs/global/global_bloc.dart';
import 'package:remotesurveyadmin/data/blocs/global/global_event.dart';
import 'package:remotesurveyadmin/firebase_options.dart';
import 'package:remotesurveyadmin/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:remotesurveyadmin/views/home/home_view.dart';

import 'components/body.dart';

class WelcomeView extends StatelessWidget {
  static String routeName = "/login_success";
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    WidgetsBinding.instance.addPostFrameCallback((_) async => {
      debugPrint("Firebase is set"),
      debugPrint("Notification ${context.read<GlobalBloc>().state.notifications}"),

      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? message) {
        if (message != null) {
          Navigator.pushNamed(
            context,
            HomeView.routeName,
            arguments: message.messageId,
          );
        }
      }),
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        context.read<GlobalBloc>().add(NotificationReceived(
            note: context.read<GlobalBloc>().state.notifications + 1));
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null && !kIsWeb) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: 'launch_background',
              ),
            ),
          );
        }
      }),
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('A new onMessageOpenedApp event was published!');
        Navigator.pushNamed(
          context,
          HomeView.routeName,
          arguments: message.messageId,
        );
      })
    });
    SizeConfig().init(context);
    context.read<GlobalBloc>().add(SessionStarted());
    return Scaffold(
      body: Body(),
    );
  }
}
