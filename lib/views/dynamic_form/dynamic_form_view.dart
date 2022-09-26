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
          iconTheme: Theme.of(context).iconTheme,
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
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
            actions: [
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () async {},
              ),
              const SizedBox(width: 12),
            ]
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
