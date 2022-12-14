import 'package:remotesurveyadmin/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:remotesurveyadmin/widgets/custom_bottom_nav_bar.dart';
import 'package:remotesurveyadmin/config/enums.dart';
import 'package:remotesurveyadmin/widgets/drawer_nav.dart';
import 'components/body.dart';

class HomeView extends StatelessWidget {
  static String routeName = "/home";

  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      drawer: const DashboardDrawerView(),
      bottomNavigationBar: const SizedBox(
          height: customBottomNavigationBarHeight,
          child: CustomBottomNavBar(selectedMenu: MenuState.home)),
    );
  }
}
