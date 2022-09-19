import 'package:remotesurveyadmin/config/size_config.dart';
import 'package:flutter/material.dart';

import '../reset_password/components/body.dart';

class ResetPasswordView extends StatelessWidget {
  static String routeName = "/reset_password";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
  }
}
