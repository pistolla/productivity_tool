import 'package:remotesurveyadmin/views/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:remotesurveyadmin/views/register/register_view.dart';

import '../config/constants.dart';
import '../config/size_config.dart';

class FoundLoginText extends StatelessWidget {
  const FoundLoginText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Try again? ",
          style: TextStyle(fontSize: getProportionateScreenWidth(16)),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, LoginView.routeName),
          child: Text(
            "Login",
            style: TextStyle(
                fontSize: getProportionateScreenWidth(16),
                color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
