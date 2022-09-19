import 'package:flutter/material.dart';
import 'package:remotesurveyadmin/config/constants.dart';
import 'package:remotesurveyadmin/views/dynamic_form/body/dynamic_form_screen.dart';


class DynamicFormView extends StatelessWidget {
  static String routeName = "/dynamic_form";

  const DynamicFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete the survey below'),
        backgroundColor: kPrimaryColor,
      ),
      body: const DynamicFormScreen(),
    );
  }
}