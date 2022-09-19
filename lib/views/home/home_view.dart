import 'package:remotesurveyadmin/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:remotesurveyadmin/widgets/custom_bottom_nav_bar.dart';
import 'package:remotesurveyadmin/config/enums.dart';
import 'components/body.dart';

class HomeView extends StatelessWidget {
  static String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      bottomNavigationBar: SizedBox(
          height: customBottomNavigationBarHeight,
          child: CustomBottomNavBar(selectedMenu: MenuState.home)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        elevation: 4,
        splashColor: kPrimaryLightColor,
        child: const Icon(
          Icons.add,
          color: Colors.green,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
