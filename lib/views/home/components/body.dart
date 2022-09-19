import 'package:remotesurveyadmin/config/size_config.dart';
import 'package:remotesurveyadmin/models/survey_data_source.dart';
import 'package:remotesurveyadmin/models/survey_model.dart';
import 'package:remotesurveyadmin/views/home/components/section_title.dart';
import 'package:remotesurveyadmin/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../helper/date_formatter_util.dart';

class Body extends StatelessWidget {
  List<Survey> surveys = <Survey>[];
  late SurveyDataSource surveyDataSorce;

  List<String> _accValues = ["select "];

  List<String> _dropDownValues = ["Filter by:"];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: kPrimaryColor,
    ));
    surveys = getSurveyData();
    surveyDataSorce = SurveyDataSource(employeeData: surveys);
    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            systemOverlayStyle:
                const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
            pinned: true,
            snap: false,
            floating: true,
            stretch: true,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Stack(fit: StackFit.expand, children: <Widget>[
                Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        child: DropdownButton(
                          iconEnabledColor: Colors.white,
                          dropdownColor: kPrimaryColor,
                          items: _accValues
                              .map((value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(color: Colors.white),
                                  )))
                              .toList(),
                          onChanged: (value) {},
                          isExpanded: false,
                          value: _accValues.first,
                        ))),
                Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text("Total quiz",
                              style:
                                  TextStyle(color: kTextColor, fontSize: 20.0)),
                          Text("1",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
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
                    child: SizedBox(
                      height: 40, // 40
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: kPlainColor),
                            child: DropdownButton(
                              iconEnabledColor: kPrimaryColor,
                              items: _dropDownValues
                                  .map((value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(color: kPrimaryColor),
                                      )))
                                  .toList(),
                              onChanged: (value) {},
                              isExpanded: false,
                              value: _dropDownValues.first,
                            ),
                          ),
                          const Spacer(),
                          const Text("Selected drop down")
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            backgroundColor: kPrimaryColor,
            leading: IconButton(
              icon: const Icon(Icons.home_outlined, color: Colors.white),
              onPressed: () {},
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () async {},
              ),
              const SizedBox(width: 12),
            ],
          ),
          SliverToBoxAdapter(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SectionTitle(
                    title: 'Active Survey',
                    press: () {},
                  ))),
          SliverToBoxAdapter(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: SfDataGrid(
                          source: surveyDataSorce,
                          columnWidthMode: ColumnWidthMode.lastColumnFill,
                          columns: <GridColumn>[
                            GridColumn(
                                columnName: 'id',
                                label: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'ID',
                                    ))),
                            GridColumn(
                                columnName: 'name',
                                label: Container(
                                    padding: EdgeInsets.all(8.0),
                                    alignment: Alignment.center,
                                    child: Text('Quiz name'))),
                            GridColumn(
                                columnName: 'designation',
                                label: Container(
                                    padding: EdgeInsets.all(8.0),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Date created',
                                      overflow: TextOverflow.ellipsis,
                                    ))),
                            GridColumn(
                                columnName: 'questions',
                                label: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    alignment: Alignment.center,
                                    child: Text('No of questions'))),
                            GridColumn(
                                columnName: 'answers',
                                label: Container(
                                    padding: EdgeInsets.all(8.0),
                                    alignment: Alignment.center,
                                    child: Text('Answers'))),
                            GridColumn(
                                columnName: 'action',
                                label: Container(
                                    padding: EdgeInsets.all(8.0),
                                    alignment: Alignment.center,
                                    child: Text('Action', style: TextStyle(color: Colors.blueAccent),))),
                          ],
                        ),
                      ))))
        ],
      ),
    );
  }

  List<Survey> getSurveyData() {
    return [
      Survey(1, "User survey",
          DateFormatterUtil().serverFormattedDate(DateTime.now()), 15, 0, 10),
    ];
  }
}
