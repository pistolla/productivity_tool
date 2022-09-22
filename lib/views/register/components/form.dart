import 'package:remotesurveyadmin/api/auth_service.dart';
import 'package:remotesurveyadmin/storage/session.dart';
import 'package:remotesurveyadmin/views/login/login_view.dart';
import 'package:remotesurveyadmin/widgets/adaptive/alert_dialog/adaptive_alert_dialog_factory.dart';
import 'package:flutter/material.dart';
import 'package:remotesurveyadmin/widgets/form_error.dart';
import 'package:remotesurveyadmin/config/constants.dart';
import 'package:remotesurveyadmin/config/size_config.dart';
import 'package:remotesurveyadmin/views/home/home_view.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? first_name;
  String? last_name;
  String? email;
  String? phone;
  String? password;
  String? confirm_password;
  bool remember = false;
  bool _isObsure = true;
  final List<String?> errors = [];
  var responseMessage = "Loading...";

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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildFirstnameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildLastnameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneFormField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildConfirmPassFormField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          GestureDetector(
            onTap: () {

            },
            child: Text(
              'By signing up, you confirm that you agree \nwith our Term and Condition (Bypass to home)',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(50)),
          Row(
            children: [
              OutlinedButton(
                onPressed: () {
                  Future.delayed(Duration.zero, () {
                    Navigator.pushNamed(context, LoginView.routeName);
                  });
                },
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10)),
                child: const Text("Login"),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => {
                  if (_formKey.currentState!.validate())
                    {
                      debugPrint("save state"),
                      _formKey.currentState!.save(),
                      addNewUser()
                    },
                },
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10)),
                child: const Text("Register"),
              )
            ],
          ),
        ],
      ),
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

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: _isObsure,
      onSaved: (newValue) => confirm_password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 5) {
          removeError(error: kShortPassError);
        }
        password = value;
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
          labelText: "Enter Password",
          hintText: "Enter your password",
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

  TextFormField buildEmailFormField() {
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
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Align(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: Icon(Icons.mail_outline),
        ),
      ),
    );
  }

  TextFormField buildFirstnameFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => first_name = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "First name",
        hintText: "Enter your first name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Align(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: Icon(Icons.account_circle_rounded),
        ),
      ),
    );
  }

  TextFormField buildLastnameFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => last_name = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Last name",
        hintText: "Enter your last name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Align(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: Icon(Icons.account_circle_rounded),
        ),
      ),
    );
  }

  TextFormField buildPhoneFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phone = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Mobile Number",
        hintText: "Enter your phone number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Align(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: Icon(Icons.phone),
        ),
      ),
    );
  }

  showProcessDialog(BuildContext context) {
    isLoading = 0;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            _setState = setState;
            return AdaptiveAlertDialogFactory.showInditerminate(context,
                content: responseMessage, status: isLoading);
          });
        });
  }

  addNewUser() {
    debugPrint("addNewUser");
    responseMessage = "Loading...";
    showProcessDialog(context);
    AuthService service = AuthService();
    service.newUser({
      "email": email,
      "phone": phone,
      "names": "$first_name $last_name",
      "pass0": password,
      "pass1": confirm_password
    }).then(
      (value) => {
        Future.delayed(const Duration(milliseconds: 5000), () {
          if (value.serverResponse != null) {
            if (value.error != null) {
              _setState(() {
                responseMessage = value.error.toString();
                addError(error: value.error.toString());
                isLoading = 2;
              });
              Future.delayed(const Duration(milliseconds: 5000), () {
                Navigator.pop(context);
              });
            } else if (value.serverResponse.status != null) {
              if (value.serverResponse.status == 1) {
                _setState(() {
                  removeError(error: value.serverResponse.statusDesc);
                  addError(error: value.serverResponse.statusDesc);
                  responseMessage = value.serverResponse.statusDesc;
                  isLoading = 2;
                });
                Future.delayed(const Duration(milliseconds: 5000), () {
                  Navigator.pop(context);
                });
              } else if (value.serverResponse.status == 0) {
                _setState(() {
                  responseMessage = value.serverResponse.statusDesc;
                  isLoading = 1;
                });
                Session session = Session();
                session.storeIsFirstLaunch(isFirstLaunch: true);
                session.storeUsername(userName: "$first_name");
                session.storeUserphone(userPhone: phone.toString());
                session.storeUserID(userID: value.serverResponse.data["user"]);
                session.tokens
                    .storeAccessToken(value.serverResponse.data["token"]);
                Navigator.pop(context);
                Navigator.pushNamed(context, LoginView.routeName);
              }
            }
          } else {
            _setState(() {
              responseMessage = value.error!.error;
              addError(error: "Failed: ${value.error!.error}");
              isLoading = 2;
            });
            Navigator.pop(context);
          }
        }),
      },
    );
  }
}
