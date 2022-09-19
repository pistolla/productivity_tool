import 'package:remotesurveyadmin/config/constants.dart';
import 'package:remotesurveyadmin/data/blocs/global/global_bloc.dart';
import 'package:remotesurveyadmin/data/blocs/global/global_event.dart';
import 'package:remotesurveyadmin/data/blocs/global/global_state.dart';
import 'package:remotesurveyadmin/views/account/account_view.dart';
import 'package:remotesurveyadmin/views/login/login_view.dart';
import 'package:remotesurveyadmin/views/profile/components/profile_menu_notifiable.dart';
import 'package:remotesurveyadmin/views/setting/setting_view.dart';
import 'package:remotesurveyadmin/widgets/adaptive/alert_dialog/adaptive_alert_dialog_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: kPrimaryColor,
    ));
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          systemOverlayStyle:
          SystemUiOverlayStyle(statusBarColor: Colors.transparent),
          pinned: true,
          snap: false,
          floating: true,
          stretch: true,
          expandedHeight: 200.0,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: Stack(fit: StackFit.expand, children: <Widget>[

              BlocBuilder<GlobalBloc, GlobalState>(buildWhen: (context, state) {
                return state is SessionUpdated;
              }, builder: (context, state) {
                return Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ProfilePic(),
                        ],
                      ),
                    ));
              }),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  child: Container(
                    height: 40, // 40
                    child: Row(
                      children: [],
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
          backgroundColor: kPrimaryColor,
          leading: IconButton(
            icon: Icon(Icons.refresh_outlined, color: Colors.white),
            onPressed: () {
              showProcessDialog(context);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pushNamed(SettingView.routeName);
              },
            ),
          ],
        ),
        SliverToBoxAdapter(
            child: ProfileMenu(
              text: "My Account",
              icon: Icons.person,
              press: () =>
              {
                Navigator.of(context).pushNamed(AccountView.routeName)
              },
            )),
        SliverToBoxAdapter(
            child: ProfileMenuNotif(
              text: "Notifications",
              icon: Icons.notifications,
              press: () {

              },
            )),
        SliverToBoxAdapter(
            child: ProfileMenu(
              text: "Settings",
              icon: Icons.settings,
              press: () {
                Navigator.of(context).pushNamed(SettingView.routeName);
              },
            )),
        SliverToBoxAdapter(
            child: ProfileMenu(
              text: "Help Center",
              icon: Icons.help_center_outlined,
              press: () {

              },
            )),
        SliverToBoxAdapter(
            child: ProfileMenu(
              text: "Log Out",
              icon: Icons.lock_outline,
              press: () {
                BlocProvider.of<GlobalBloc>(context).add(SessionEnded());
                Navigator.of(context).pushNamed(LoginView.routeName);
              },
            )),
      ],
    );
  }

  showProcessDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AdaptiveAlertDialogFactory.showInditerminate(context,
              content: "checking notifications...", status: 0);
        });
    Future.delayed(const Duration(milliseconds: 8000), () {
      Navigator.pop(context);
    });
  }
}
