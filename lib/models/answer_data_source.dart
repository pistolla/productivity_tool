import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remotesurveyadmin/api/auth_service.dart';
import 'package:remotesurveyadmin/api/firestore_service.dart';
import 'package:remotesurveyadmin/helper/date_formatter_util.dart';
import 'package:remotesurveyadmin/models/answer_model.dart';
import 'package:remotesurveyadmin/models/notification_model.dart';
import 'package:remotesurveyadmin/storage/session.dart';
import 'package:remotesurveyadmin/views/dynamic_form/dynamic_form_data.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart'
    as components;

import 'package:remotesurveyadmin/views/dynamic_form/body/transition_form_builder.dart';

import '../data/blocs/form/dynamic_form_bloc.dart';
import 'form_model.dart';

class AnswerDataSource extends DataGridSource {
  AnswerDataSource({required FormModel formData}) {
    _cloudForms = formData.data.map<DataGridRow>((e) {
      var answer = AnswerModel.fromMap(e);
      var val = DateFormatterUtil().serverFormattedDate(
          DateTime.parse(answer.published_on.toDate().toString()));
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'question_1', value: formData.title),
        DataGridCell<String>(columnName: 'question_2', value: val),
        DataGridCell<String>(
            columnName: 'question_3', value: answer.getQuestion(1)["value"]),
        DataGridCell<String>(
            columnName: 'question_4', value: answer.getQuestion(2)["value"]),
        DataGridCell<String>(
            columnName: 'question_5', value: answer.getQuestion(3)["value"]),
        DataGridCell<Map>(columnName: 'action', value: {
          "id": e.documentId,
          "title": e.title,
          "tabs": formData.getTabs()
        }),
      ]);
    }).toList();
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
                  return IconButton(
                      icon: const Icon(Icons.open_in_new,
                          size: 30, color: Colors.greenAccent),
                      onPressed: () {

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
                              child: DynamicFormDataView(
                                documentId: e.value["id"],
                                title: e.value["title"],
                                tabs: e.value["tabs"],
                              ),
                            ),
                          ),
                        );
                      });
                })
              : Text(e.value.toString()));
    }).toList());
  }
}
