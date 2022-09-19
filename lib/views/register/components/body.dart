import 'package:flutter/material.dart';
import 'package:remotesurveyadmin/config/constants.dart';
import 'package:remotesurveyadmin/config/size_config.dart';

import 'form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04), // 4%
                Align(
                  alignment: Alignment.center,
                  heightFactor: 1.0,
                  widthFactor: 1.0,
                  child: Icon(Icons.person,size: 65.0, color: kPrimaryColor),
                ),
                Text("New User", style: headingStyle),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                SignUpForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
