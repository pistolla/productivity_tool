import 'package:remotesurveyadmin/api/auth_service.dart';
import 'package:remotesurveyadmin/data/blocs/global/global_bloc.dart';
import 'package:remotesurveyadmin/data/blocs/global/global_event.dart';
import 'package:remotesurveyadmin/storage/session.dart';
import 'package:remotesurveyadmin/storage/storage_keys.dart';
import 'package:remotesurveyadmin/widgets/adaptive/alert_dialog/adaptive_alert_dialog_factory.dart';
import 'package:remotesurveyadmin/views/forgot_password/forgot_password_view.dart';
import 'package:remotesurveyadmin/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:remotesurveyadmin/widgets/form_error.dart';
import 'package:remotesurveyadmin/widgets/no_account_text.dart';
import 'package:remotesurveyadmin/config/constants.dart';
import 'package:remotesurveyadmin/config/size_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool? remember = true;
  bool _isObsure = true;
  final List<String?> errors = [];

  String responseMessage = "Loading...";

  int isLoading = 0;

  late StateSetter _setState;

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  void clearErrors() {
    setState(() {
      errors.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailPhoneFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(10)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              const Text("Remember me"),
              const Spacer(),
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, ForgotPasswordView.routeName),
                child: const Text("Forgot Password?"),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          const NoAccountText(),
          SizedBox(height: getProportionateScreenHeight(300)),
          Row(
            children: [
              const Spacer(),
              ElevatedButton(
                onPressed: () => {
                  if (_formKey.currentState!.validate())
                    {
                      debugPrint("save state"),
                      _formKey.currentState!.save(),
                      loginUser()
                    },
                },
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10)),
                child: const Text("Login"),
              )
            ],
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: _isObsure,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 5) {
          removeError(error: kShortPassError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 5) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Password",
          hintText: "Enter your password",
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: const Align(
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

  TextFormField buildEmailPhoneFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then label text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Align(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: Icon(Icons.mail_outline),
        ),
      ),
    );
  }

  showProcessDialog(BuildContext context) {
    isLoading = 0;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext cxt) {
          return StatefulBuilder(builder: (c, setState) {
            _setState = setState;
            return AdaptiveAlertDialogFactory.showInditerminate(c,
                content: responseMessage, status: isLoading);
          });
        });
  }

  loginUser() {
    debugPrint("login");
    responseMessage = "Requesting...";
    clearErrors();
    showProcessDialog(context);
    AuthService service = AuthService();

    service.authenticate({"email": email, "password": password}).then(
      (value) => {
        Future.delayed(const Duration(milliseconds: 3000), () {
          if (value.serverResponse != null) {
            if (value.error != null) {
              debugPrint("error response ${value.error}");
              _setState(() {
                responseMessage = value.error.toString();
                addError(error: value.error.toString());
                isLoading = 2;
              });
              Navigator.pop(context);
            } else if (value.serverResponse != null) {
              debugPrint("error response ${value.serverResponse.statusDesc}");
              _setState(() {
                responseMessage = value.serverResponse.statusDesc;
                isLoading = 1;
              });
              Session session = Session();
              session.storeIsFirstLaunch(isFirstLaunch: false);
              session.storeUserID(userID: value.serverResponse.data["user"]);
              session.tokens
                  .storeAccessToken(value.serverResponse.data["token"]);
              session.storeSettings(values: StorageKeys.defaultSettings);
              if (remember == true) {
                session.storeCredentials(username: email!, password: password!);
              }

              context.read<GlobalBloc>().add(SessionStarted());
              Navigator.pop(context);
              Navigator.pushNamed(context, HomeView.routeName);
            }
          } else {
            debugPrint("error response ${value.error}");
            _setState(() {
              responseMessage = value.error!.error;
              addError(error: "Failed: ${value.error!.error}");
              isLoading = 2;
            });
            Navigator.pop(context);
          }
        })
      },
    );
  }
}
