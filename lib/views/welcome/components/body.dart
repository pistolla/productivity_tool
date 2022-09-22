import 'dart:async';

import 'package:remotesurveyadmin/api/auth_service.dart';
import 'package:remotesurveyadmin/api/response_data.dart';
import 'package:remotesurveyadmin/config/constants.dart';
import 'package:remotesurveyadmin/data/blocs/global/global_bloc.dart';
import 'package:remotesurveyadmin/data/blocs/global/global_event.dart';
import 'package:remotesurveyadmin/storage/preference_storage.dart';
import 'package:remotesurveyadmin/storage/secure_storage.dart';
import 'package:remotesurveyadmin/storage/session.dart';
import 'package:remotesurveyadmin/storage/storage_keys.dart';
import 'package:remotesurveyadmin/storage/token_storage.dart';
import 'package:remotesurveyadmin/views/dashboard/dashboard_view.dart';
import 'package:remotesurveyadmin/views/login/login_view.dart';
import 'package:remotesurveyadmin/views/onboard/onboard_view.dart';
import 'package:flutter/material.dart';
import 'package:remotesurveyadmin/views/home/home_view.dart';
import 'package:remotesurveyadmin/config/size_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  String user = "";
  bool isFirstTimeOpened = true;
  String token = "";
  String userID = "";

  @override
  _BodyState createState() => new _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  late Session _session;
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  String responseMessage = "Loading...";
  late AnimationController _controller;
  String message = "";
  String username = "";

  bool tryLogin = false;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((value) => {
          _session = Session(),
          _session = _session.init(
              pref: PrefStorage(sharedPref: value),
              token: TokenStorage(
                  secureStorage: SecureStorage(
                      flutterSecureStorage: const FlutterSecureStorage()))),
          _session.getIsFirstLaunch().then((value) => {
                setState(() => {message = "Authenticating session token"}),
                widget.isFirstTimeOpened = value,
                if (value)
                  {
                    Navigator.pushNamed(context, OnboardView.routeName),
                  }
                else
                  {
                    _session.tokens.getAccessToken().then((access) => {
                          if (access == null)
                            {
                              setState(() => {message = "Please Login"}),
                              Navigator.pushNamed(context, LoginView.routeName),
                            }
                          else
                            {
                              widget.token = access,
                              Future.wait([
                                _session.getUsername().then((x) => {
                                      widget.user = x,
                                      setState(() => {username = x}),
                                    }),
                                _session
                                    .getUserID()
                                    .then((x) => {widget.userID = x})
                              ]).then((value) => {
                                    context.read<GlobalBloc>().add(
                                        SessionUpdated(
                                            isFirstLaunch:
                                                widget.isFirstTimeOpened,
                                            userid: widget.userID,
                                            token: widget.token)),
                                    setState(
                                        () => {message = "authenticating..."}),
                                    _confirmAuthentic().then((value) => {
                                          if (value)
                                            {
                                              setState(() => {
                                                    message =
                                                        "checking Biometric login"
                                                  }),
                                              _bioAuthenticateMe()
                                                  .timeout(
                                                      const Duration(
                                                          seconds: 240),
                                                      onTimeout: () => false)
                                                  .then((value) => {
                                                        if (value)
                                                          {
                                                            Future.delayed(
                                                                const Duration(
                                                                    seconds: 2),
                                                                () {
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  DashboardView
                                                                      .routeName);
                                                            })
                                                          }
                                                        else
                                                          {
                                                            setState(() => {
                                                                  message =
                                                                      "Please Login"
                                                                }),
                                                            Navigator.pushNamed(
                                                                context,
                                                                LoginView
                                                                    .routeName),
                                                          },
                                                      })
                                            }
                                          else
                                            {
                                              setState(() =>
                                                  {message = "Please Login"}),
                                              Navigator.pushNamed(
                                                  context, LoginView.routeName),
                                            }
                                        }),
                                  })
                            }
                        }),
                  },
              }),
        });

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.04),
        Image.asset(
          "assets/images/welcome/success.png",
          height: SizeConfig.screenHeight * 0.4, //40%
        ),
        Text(
          "Welcome $username",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(30),
            fontWeight: FontWeight.w100,
            color: Colors.black,
          ),
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.05),
        Align(
            alignment: Alignment.center,
            heightFactor: 1.0,
            widthFactor: 1.0,
            child: ColorFiltered(
                colorFilter:
                    ColorFilter.mode(kPrimaryColor, BlendMode.modulate),
                child: Image.asset(
                  "assets/images/welcome/logo.png",
                  height: 250, //40%
                ))),
        SizedBox(height: SizeConfig.screenHeight * 0.04),
        Row(
          children: [
            Spacer(),
            Text(
              "* $message ",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(18),
                fontWeight: FontWeight.normal,
                color: kPrimaryColor,
              ),
            ),
            if (tryLogin) ...[
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, LoginView.routeName),
                child: Text(
                  "Login?",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
            Spacer(),
          ],
        ),
      ],
    );
  }

  Future<bool> _confirmAuthentic() async {
    debugPrint("confirm authentic");
    AuthService service = AuthService();
    ResponseData response = service.checkUserLoggedIn();
    if (response.error != null) {
      bool remembers = context
          .read<GlobalBloc>()
          .state
          .settings[StorageKeys.SettingRememberMe];
      if (remembers) {
        Session session = Session();
        String? email = await session.tokens.getUsername();
        String? password = await session.tokens.getPassword();
        ResponseData request =
            await service.authenticate({"email": email, "password": password});
        if (request.serverResponse != null) {
          return true;
        }
        return false;
      }
      return false;
    } else if (response.serverResponse != null) {
      return true;
    }
    return true;
  }

  Future<bool> _bioAuthenticateMe() async {
    try {
      bool authenticated = false;
      bool allowBiometric = context
          .read<GlobalBloc>()
          .state
          .settings[StorageKeys.SettingAllowBiometric];
      if (allowBiometric == true) {
        bool isBiometricSupported =
            await _localAuthentication.isDeviceSupported();
        bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
        if (isBiometricSupported && canCheckBiometrics) {
          authenticated = await _localAuthentication.authenticate(
              localizedReason: "Please authenticate using fingerprint",
              biometricOnly: true);

          if (authenticated) {
            setState(() => {message = "Successful. Redirecting to home..."});
            return true;
          } else {
            setState(() => {
                  tryLogin = true,
                  message = "Try again. Biometric authentication"
                });
            return false;
          }
        } else {
          setState(() => {message = "Biometric authentication not allowed"});
          return true;
        }
      } else {
        setState(() => {message = "Looks good. Redirecting to home..."});
        return true;
      }
    } catch (error) {
      print(error.toString());
      setState(() => {tryLogin = true, message = "Biometric is unavailable"});
      return false;
    }
  }
}
