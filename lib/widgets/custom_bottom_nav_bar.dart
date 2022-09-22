import 'package:badges/badges.dart';
import 'package:remotesurveyadmin/data/blocs/global/global_bloc.dart';
import 'package:remotesurveyadmin/data/blocs/global/global_state.dart';
import 'package:flutter/material.dart';
import 'package:remotesurveyadmin/views/answers/answer_view.dart';
import 'package:remotesurveyadmin/views/home/home_view.dart';
import 'package:remotesurveyadmin/views/profile/profile_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/constants.dart';
import '../config/enums.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({Key? key, required this.selectedMenu})
      : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    const Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.85),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                child: Column(children: [
                  IconButton(
                    icon: Icon(
                      Icons.file_copy_outlined,
                      color: MenuState.home == selectedMenu
                          ? kPrimaryColor
                          : inActiveIconColor,
                    ),
                    onPressed: () =>
                        Navigator.pushNamed(context, HomeView.routeName),
                  ),
                  Text('Home',
                      style: TextStyle(
                          color: MenuState.home == selectedMenu
                              ? kPrimaryColor
                              : inActiveIconColor)),
                ]),
              ),
              Flexible(
                child: Column(children: [
                  IconButton(
                    icon: Icon(
                      Icons.question_answer,
                      color: MenuState.answers == selectedMenu
                          ? kPrimaryColor
                          : inActiveIconColor,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AnswerView.routeName);
                    },
                  ),
                  Text('Answers',
                      style: TextStyle(
                          color: MenuState.answers == selectedMenu
                              ? kPrimaryColor
                              : inActiveIconColor)),
                ]),
              ),
              Flexible(
                child: Column(children: [
                  IconButton(
                    icon: BlocConsumer<GlobalBloc, GlobalState>(
                      listener: (BuildContext context, state) {
                        if (state is GlobalActiveState) {}
                      },
                      builder: (BuildContext context, state) {
                        if (state.notifications > 0) {
                          return Badge(
                              badgeContent: Text("${state.notifications}"),
                              child: const CircleAvatar(
                                radius: 14,
                                backgroundImage: AssetImage(
                                    "assets/images/profile/avatar.png"),
                              ));
                        } else {
                          return const CircleAvatar(
                            radius: 14,
                            backgroundImage:
                                AssetImage("assets/images/profile/avatar.png"),
                          );
                        }
                      },
                      buildWhen: (previousState, state) {
                        return state is GlobalActiveState;
                      },
                    ),
                    onPressed: () =>
                        Navigator.pushNamed(context, ProfileView.routeName),
                  ),
                  Text('Profile',
                      style: TextStyle(
                          color: MenuState.profile == selectedMenu
                              ? kPrimaryColor
                              : inActiveIconColor)),
                ]),
              )
            ],
          )),
    );
  }
}
