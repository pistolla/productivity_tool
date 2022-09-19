import 'package:remotesurveyadmin/views/login/login_view.dart';
import 'package:remotesurveyadmin/widgets/no_account_text.dart';
import 'package:flutter/material.dart';
import 'package:remotesurveyadmin/widgets/form_error.dart';
import 'package:remotesurveyadmin/widgets/found_login_text.dart';
import 'package:remotesurveyadmin/config/constants.dart';
import 'package:remotesurveyadmin/config/size_config.dart';

class ResetPasswordForm extends StatefulWidget {
  @override
  _ResetPasswordFormState createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  String? current_password;
  String? password;
  String? confirm_password;
  bool _isObsure = true;
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildCurrentPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(40)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildConfirmPassFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
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
              Spacer(),
              ElevatedButton(
                onPressed: () => {
                  Future.delayed(Duration.zero, () {
                    Navigator.pushNamed(context, LoginView.routeName);
                  })
                },
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10)),
                child: Text("Reset"),
              )
            ],
          ),
        ],
      ),
    );
  }

  TextFormField buildCurrentPasswordFormField() {
    return TextFormField(
      obscureText: _isObsure,
      onSaved: (newValue) => current_password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Password",
          hintText: "Enter the sent password",
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Align(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: Icon(Icons.lock_outline),
          ),
          suffixIcon: IconButton(
            icon: Icon(_isObsure ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _isObsure = !_isObsure;
              });
            },
          )),
    );
  }

  TextFormField buildConfirmPassFormField() {
    return TextFormField(
      obscureText: _isObsure,
      onSaved: (newValue) => confirm_password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && password == confirm_password) {
          removeError(error: kMatchPassError);
        }
        confirm_password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((password != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Re-Password",
          hintText: "Re-enter new password",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Align(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: Icon(Icons.lock_outline),
          ),
          suffixIcon: IconButton(
            icon: Icon(_isObsure ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _isObsure = !_isObsure;
              });
            },
          )),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: _isObsure,
      onSaved: (newValue) => confirm_password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Enter Password",
          hintText: "Enter your password",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Align(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: Icon(Icons.lock_outline),
          ),
          suffixIcon: IconButton(
            icon: Icon(_isObsure ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _isObsure = !_isObsure;
              });
            },
          )),
    );
  }
}
