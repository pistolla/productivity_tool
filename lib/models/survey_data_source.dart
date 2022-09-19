import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:remotesurveyadmin/models/survey_model.dart';
import 'package:remotesurveyadmin/views/dynamic_form/dynamic_form_view.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../data/blocs/form/dynamic_form_bloc.dart';
import '../views/dynamic_form/body/custom_form_manager.dart';

class SurveyDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  SurveyDataSource({required List<Survey> employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<String>(
                  columnName: 'designation', value: e.dateCreated),
              DataGridCell<int>(columnName: 'questions', value: e.questions),
              DataGridCell<int>(columnName: 'answers', value: e.answers),
              const DataGridCell<String>(columnName: 'action', value: null),
            ]))
        .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FormProvider(
                              create: (_) => CustomFormManager(),
                              child: BlocProvider(
                                create: (context) {
                                  return DynamicFormBloc(
                                      FormProvider.of<CustomFormManager>(context));
                                },
                                child: const DynamicFormView(),
                              ),
                            ),
                          ),
                        );
                      }, child: const Text('Fill Form', style: TextStyle(overflow: TextOverflow.visible),));
                })
              : Text(e.value.toString()));
    }).toList());
  }
}
