import 'package:flutter/material.dart';
import 'package:remotesurveyadmin/views/onboard/components/body.dart';
import 'package:remotesurveyadmin/config/size_config.dart';

class OnboardView extends StatelessWidget {
  static String routeName = "/onboard";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Intro()
    );
  }

}