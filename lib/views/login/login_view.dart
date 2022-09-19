import 'package:flutter/material.dart';

import '../login/components/body.dart';

class LoginView extends StatelessWidget {
  static String routeName = "/sign_in";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}
