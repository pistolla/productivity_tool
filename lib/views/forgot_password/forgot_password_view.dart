import 'package:flutter/material.dart';

import '../../config/size_config.dart';
import 'components/body.dart';

class ForgotPasswordView extends StatelessWidget {
  static String routeName = "/forgot_password";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
  }
}
