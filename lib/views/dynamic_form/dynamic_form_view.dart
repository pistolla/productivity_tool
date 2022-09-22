import 'package:flutter/material.dart';
import 'package:remotesurveyadmin/config/constants.dart';
import 'package:remotesurveyadmin/views/dynamic_form/body/dynamic_form_screen.dart';

class DynamicFormView extends StatelessWidget {
  static String routeName = "/dynamic_form";
  final String documentId;
  final String title;
  final List<String> tabs;

  const DynamicFormView(
      {required this.documentId,
      required this.title,
      required this.tabs,
      super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: kPlainColor,
          title: Text(
            title,
            style: Theme.of(context).textTheme.headline4,
          ),
          backgroundColor: kPrimaryColor,
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              ...tabs.map((e) => Tab(
                    text: e,
                  ))
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ...tabs.map((value) {
              var index = tabs.indexOf(value);
              return DynamicFormScreen(
                  documentId: documentId, formNumber: index, title: title);
            })
          ],
        ),
      ),
    );
  }
}
