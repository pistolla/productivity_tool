import 'package:flutter/material.dart';
import 'components/body.dart';

class DashboardView extends StatelessWidget {
  static String routeName = "/dashboard";

  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body()
    );
  }
}
