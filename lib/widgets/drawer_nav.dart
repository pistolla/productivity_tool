

import 'package:flutter/material.dart';
import 'package:remotesurveyadmin/config/constants.dart';
import 'package:remotesurveyadmin/views/dashboard/dashboard_view.dart';
import 'package:remotesurveyadmin/views/setting/setting_view.dart';

class DashboardDrawerView extends StatelessWidget {
  const DashboardDrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: kPrimaryColor,
            ),
            child: Icon(Icons.question_answer, size: 85, color: Colors.white),
          ),
          ListTile(
            title: Text('DASHBOARD', style: Theme.of(context).textTheme.headline5,),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, DashboardView.routeName);
            },
          ),
          ListTile(
            title: Text('TODOS', style: Theme.of(context).textTheme.headline5),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('SCHEDULER', style: Theme.of(context).textTheme.headline5),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('SETTINGS', style: Theme.of(context).textTheme.headline5),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, SettingView.routeName);
            },
          )
        ],
      ),
    );
  }

}