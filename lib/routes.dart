// We use name route
// All our routes will be available here
import 'package:remotesurveyadmin/views/answers/answer_view.dart';
import 'package:remotesurveyadmin/views/complete_profile/complete_profile_view.dart';
import 'package:remotesurveyadmin/views/dashboard/dashboard_view.dart';
import 'package:remotesurveyadmin/views/forgot_password/forgot_password_view.dart';
import 'package:remotesurveyadmin/views/home/home_view.dart';
import 'package:remotesurveyadmin/views/login/login_view.dart';
import 'package:remotesurveyadmin/views/onboard/onboard_view.dart';
import 'package:remotesurveyadmin/views/otp/otp_view.dart';
import 'package:remotesurveyadmin/views/profile/profile_view.dart';
import 'package:remotesurveyadmin/views/register/register_view.dart';
import 'package:remotesurveyadmin/views/reset_password/reset_password_view.dart';
import 'package:remotesurveyadmin/views/setting/setting_view.dart';
import 'package:remotesurveyadmin/views/welcome/welcome_view.dart';
import 'package:flutter/material.dart';

import 'views/account/account_view.dart';

final Map<String, WidgetBuilder> routes = {
  OnboardView.routeName: (context) => OnboardView(),
  RegisterView.routeName: (context) => RegisterView(),
  LoginView.routeName: (context) => LoginView(),
  ForgotPasswordView.routeName: (context) => ForgotPasswordView(),
  ResetPasswordView.routeName: (context) => ResetPasswordView(),
  WelcomeView.routeName: (context) => WelcomeView(),
  HomeView.routeName: (context) => HomeView(),
  OtpView.routeName: (context) => OtpView(),
  ProfileView.routeName: (context) => ProfileView(),
  AccountView.routeName: (context) => AccountView(),
  SettingView.routeName: (context) => SettingView(),
  CompleteProfileView.routeName: (context) => CompleteProfileView(),
  DashboardView.routeName: (context) => const DashboardView(),
  AnswerView.routeName: (context) =>  AnswerView()
};