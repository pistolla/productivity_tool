import 'package:remotesurveyadmin/widgets/found_login_text.dart';
import 'package:flutter/material.dart';
import 'package:remotesurveyadmin/widgets/default_button.dart';
import 'package:remotesurveyadmin/widgets/form_error.dart';
import 'package:remotesurveyadmin/widgets/no_account_text.dart';
import 'package:remotesurveyadmin/config/size_config.dart';

import '../../../config/constants.dart';
import '../../reset_password/reset_password_view.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.08), // 4%
              Align(
                alignment: Alignment.center,
                heightFactor: 1.0,
                widthFactor: 1.0,
                child: Icon(Icons.mark_email_unread_outlined,size: 65.0, color: kPrimaryColor),
              ),
              Text("Forgot Password", style: headingStyle),
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              Text(
                "Please enter your email and we will send \nyou a one time password to your account",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.05),
              ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String? email;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email = newValue,
            onChanged: (value) {
              if (value.isNotEmpty && errors.contains(kEmailNullError)) {
                setState(() {
                  errors.remove(kEmailNullError);
                });
              } else if (emailValidatorRegExp.hasMatch(value) &&
                  errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.remove(kInvalidEmailError);
                });
              }
              return null;
            },
            validator: (value) {
              if (value!.isEmpty && !errors.contains(kEmailNullError)) {
                setState(() {
                  errors.add(kEmailNullError);
                });
              } else if (!emailValidatorRegExp.hasMatch(value) &&
                  !errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.add(kInvalidEmailError);
                });
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              prefixIcon: Align(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: Icon(Icons.mail_outline),
              ),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          NoAccountText(),
          SizedBox(height: getProportionateScreenHeight(20)),
          Text(
            '-------- or ----------',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption,
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          FoundLoginText(),
          SizedBox(height: SizeConfig.screenHeight * 0.2),
          Row(
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, ResetPasswordView.routeName);
                },
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10)),
                child: Text("Reset Password"),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () => {
                  if (_formKey.currentState!.validate()) {
                    // Do what you want to do
                  }
                },
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10)),
                child: Text("Send"),
              )
            ],
          ),
        ],
      ),
    );
  }
}
