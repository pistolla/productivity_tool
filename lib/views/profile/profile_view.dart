import 'package:remotesurveyadmin/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:remotesurveyadmin/widgets/custom_bottom_nav_bar.dart';
import 'package:remotesurveyadmin/config/enums.dart';

import 'components/body.dart';

class ProfileView extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      bottomNavigationBar: SizedBox(height: customBottomNavigationBarHeight, child: CustomBottomNavBar(selectedMenu: MenuState.profile))
    );
  }
}
