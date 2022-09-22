import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:remotesurveyadmin/api/firestore_service.dart';
import 'package:remotesurveyadmin/helper/date_formatter_util.dart';
import 'package:remotesurveyadmin/models/notification_model.dart';
import 'package:remotesurveyadmin/storage/session.dart';
import 'package:remotesurveyadmin/views/dynamic_form/dynamic_form_view.dart';
import 'package:remotesurveyadmin/views/dynamic_form/body/transition_form_builder.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart'
    as components;

import '../data/blocs/form/dynamic_form_bloc.dart';
import '../views/dynamic_form/body/custom_form_manager.dart';
import 'form_model.dart';

class FormDataSource extends DataGridSource {
  FormDataSource({required List<FormModel> formData}) {
    _cloudForms = formData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'title', value: e.title),
              DataGridCell<String>(
                  columnName: 'description', value: e.description),
              DataGridCell<Map>(columnName: 'rules', value: e.rules),
              DataGridCell<int>(columnName: 'answers', value: e.data.length),
              DataGridCell<Map>(
                  columnName: 'action',
                  value: {"id": e.documentId, "title": e.title, "tabs": e.getTabs()}),
            ]))
        .toList();
  }

  List<DataGridRow> _cloudForms = [];

  @override
  List<DataGridRow> get rows => _cloudForms;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: e.columnName == 'action'
              ? LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                  return ElevatedButton(
                      onPressed: () {
                        Session session = Session();
                        session.getUserID().then((userId) {
                          session.getUsername().then((value) {
                            var message =
                                "user has started filing form ${e.value["title"]} ";
                            var timestamp = Timestamp.fromDate(DateTime.now());
                            var user_id = userId;
                            var reference = e.value["id"];

                            FirestoreService service = FirestoreService();
                            service.createNotification(NotificationModel(
                                id: '',
                                message: message,
                                date_created: timestamp,
                                reference: reference,
                                user_id: user_id));
                          });
                        });
                        var formBuilder = FormBuilder(
                          JsonFormParserService(
                            components.getDefaultParserList(),
                          ),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                                create: (context) {
                                  return DynamicFormBloc(formBuilder,
                                      TransitionFormBuilder(formBuilder));
                                },
                                child: DynamicFormView(
                                  documentId: e.value["id"],
                                  title: e.value["title"],
                                  tabs: e.value["tabs"],
                                ),
                              ),

                          ),
                        );
                      },
                      child: const Text(
                        'Fill Form',
                        style: TextStyle(overflow: TextOverflow.visible),
                      ));
                })
              : e.columnName == 'rules'
                  ? LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                      var ruleMap = e.value as Map;
                      return Row(
                        children: [
                          ...ruleMap.entries.map((entry) {
                            if (entry.value is Timestamp) {
                              var val = DateFormatterUtil().serverFormattedDate(
                                  DateTime.parse(
                                      entry.value.toDate().toString()));
                              return Text('${entry.key}: $val ');
                            }
                            return Text('${entry.key}: ${entry.value} ');
                          })
                        ],
                      );
                    })
                  : Text(e.value.toString()));
    }).toList());
  }
}
