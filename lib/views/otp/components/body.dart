import 'package:remotesurveyadmin/api/auth_service.dart';
import 'package:remotesurveyadmin/storage/session.dart';
import 'package:remotesurveyadmin/widgets/adaptive/alert_dialog/adaptive_form_dialog_factory.dart';
import 'package:flutter/material.dart';
import 'package:remotesurveyadmin/config/constants.dart';
import 'package:remotesurveyadmin/config/size_config.dart';

import 'otp_form.dart';

class Body extends StatelessWidget {
  var phone;
  var verity = false;
  bool canSend = false;

  @override
  Widget build(BuildContext context) {
    Session session = Session();
    session.getUserphone().then((value) => {
          if (value.isNotEmpty) {phone = value}
        });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (phone != null) {
        AuthService service = AuthService();
        service.verifyPhoneNumber({"phone": phone}).forEach((element) {
          if (element.error != null) {
          } else if (element.serverResponse != null) {}
        });
      }
    });

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.05),
              const Align(
                alignment: Alignment.center,
                heightFactor: 1.0,
                widthFactor: 1.0,
                child: Icon(Icons.vpn_key, size: 65.0, color: kPrimaryColor),
              ),
              Text(
                "OTP Verification",
                style: headingStyle,
              ),
              Text("We sent your code to $phone"),
              buildTimer(),
              const OtpForm(),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              GestureDetector(
                onTap: () {
                  AdaptiveFormDialogFactory.showOKAlert(context,
                      title: 'Resend OTP',
                      child: SizedBox(
                          width: 400,
                          height: 90,
                          child: TweenAnimationBuilder(
                              tween: Tween(begin: 30.0, end: 0.0),
                              duration: const Duration(seconds: 30),
                              builder: (_, dynamic value, child) {
                                if (value != 0) {
                                  return Text(
                                    "We are re-sending in 00:${value.toInt()}",
                                    style:
                                        const TextStyle(color: kPrimaryColor),
                                  );
                                } else {
                                  canSend = true;
                                  return const Text("Code sent!");
                                }
                              })), onPressed: () {
                    if (canSend) {
                      Navigator.of(
                        context,
                        rootNavigator: false,
                      ).pop();
                    }
                  });
                },
                child: const Text(
                  "Resend OTP Code",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              Row(children: [
                const Spacer(),
                const Text(
                  "Allow biometric login",
                  textAlign: TextAlign.center,
                ),
                Switch(
                    value: verity,
                    onChanged: (change) => {
                          verity = change,
                          session.storeBiometricLogin(allow: verity)
                        }),
                const Spacer()
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("This code will expired in "),
        TweenAnimationBuilder(
          tween: Tween(begin: 30.0, end: 0.0),
          duration: const Duration(seconds: 30),
          builder: (_, dynamic value, child) => Text(
            "00:${value.toInt()}",
            style: const TextStyle(color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
