import 'package:flutter/material.dart';
import 'package:remotesurveyadmin/widgets/no_account_text.dart';
import 'package:remotesurveyadmin/widgets/social_button.dart';
import '../../../config/constants.dart';
import '../../../config/size_config.dart';
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
                const Align(
                  alignment: Alignment.center,
                  heightFactor: 1.0,
                  widthFactor: 1.0,
                  child: Icon(Icons.lock_open_rounded,size: 65.0, color: kPrimaryColor),
                ),
                Text("Login", style: headingStyle),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                SignForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
