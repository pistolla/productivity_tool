import 'package:flutter/material.dart';

import '../../config/size_config.dart';
import 'components/body.dart';

class RegisterView extends StatelessWidget {
  static String routeName = "/sign_up";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
  }
}
