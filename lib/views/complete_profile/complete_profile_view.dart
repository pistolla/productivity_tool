import 'package:flutter/material.dart';

import 'components/body.dart';

class CompleteProfileView extends StatelessWidget {
  static String routeName = "/complete_profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit account information'),
      ),
      body: Body(),
    );
  }
}
