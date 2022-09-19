import 'package:flutter/material.dart';
import 'package:remotesurveyadmin/config/size_config.dart';

import 'components/body.dart';

class OtpView extends StatelessWidget {
  static String routeName = "/otp";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
  }
}
