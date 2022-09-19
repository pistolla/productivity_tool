import 'package:badges/badges.dart';
import 'package:remotesurveyadmin/data/blocs/global/global_bloc.dart';
import 'package:remotesurveyadmin/data/blocs/global/global_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../config/constants.dart';

class ProfileMenuNotif extends StatelessWidget {
  const ProfileMenuNotif({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: kPrimaryColor,
          padding: EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            Icon(icon, color: kPrimaryColor, size: 22),
            SizedBox(width: 20),
            Expanded(child: Text(text)),
            BlocConsumer<GlobalBloc, GlobalState>(
              listener: (BuildContext context, state) {
                if (state is GlobalActiveState) {}
              },
              builder: (BuildContext context, state) {
                if (state.notifications > 0) {
                  return Badge(
                      child: Icon(Icons.arrow_forward_ios),
                      badgeContent: Text("${state.notifications}"));
                } else {
                  return Icon(Icons.arrow_forward_ios);
                }
              },
              buildWhen: (previousState, state) {
                return state is GlobalActiveState;
              },
            ),
          ],
        ),
      ),
    );
  }
}
