import 'package:remotesurveyadmin/api/firestore_service.dart';
import 'package:remotesurveyadmin/config/size_config.dart';
import 'package:remotesurveyadmin/models/answer_data_source.dart';
import 'package:remotesurveyadmin/models/form_model.dart';
import 'package:remotesurveyadmin/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class Body extends StatelessWidget {
  late AnswerDataSource surveyDataSorce;

  List<String> _dropDownValues = [];
  static final ValueNotifier<List<String>> tasksNotifier = ValueNotifier([]);
  String selectedValue = "";
  int total = 0;

  Body({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: kPrimaryColor,
    ));
    _dropDownValues = ["Filter by:"];
    selectedValue = _dropDownValues.first;
    surveyDataSorce = AnswerDataSource(formData: FormModel.dummy());
    FirestoreService service = FirestoreService();
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
            expandedHeight: 150.0,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Stack(fit: StackFit.expand, children: <Widget>[
                Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      child: Text("Survey Answers",
                          style: Theme.of(context).textTheme.headline5),
                    )),
                Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          StreamBuilder(
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.active ||
                                    snapshot.connectionState ==
                                        ConnectionState.done) {
                                  if (snapshot.hasData) {
                                    var values = snapshot.data as List;
                                    return Text("Total ${values.length}",
                                        style: const TextStyle(
                                            color: kTextColor, fontSize: 40.0));
                                  }
                                }
                                return Text("Total $total",
                                    style: const TextStyle(
                                        color: kTextColor, fontSize: 40.0));
                              },
                              stream: service.listenToPostsRealTime())
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
                          offset:
                              const Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: 40, // 40
                      child: Row(
                        children: [
                          Text("Select Quiz",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline6),
                          const Spacer(),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: kPlainColor),
                              child: StreamBuilder(
                                  builder: (BuildContext context,
                                      AsyncSnapshot<dynamic> snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.active ||
                                        snapshot.connectionState ==
                                            ConnectionState.done) {
                                      if (snapshot.hasData) {
                                        var values = snapshot.data as List;
                                        _dropDownValues.clear();
                                        _dropDownValues.add("Filter by:");
                                        for (var element in values) {
                                          var attri = element as FormModel;
                                          _dropDownValues.add(attri.documentId);
                                        }
                                        return DropdownButton(
                                          iconEnabledColor: kPrimaryColor,
                                          items: _dropDownValues
                                              .map((item) => DropdownMenuItem(
                                                  value: item,
                                                  child: Text(
                                                    item,
                                                    style: const TextStyle(
                                                        color: kPrimaryColor),
                                                  )))
                                              .toList(),
                                          onChanged: (value) {
                                            if (value != null) {
                                              tasksNotifier.value = [value];
                                              selectedValue = value;
                                            }
                                          },
                                          isExpanded: false,
                                          value: selectedValue,
                                        );
                                      }
                                    }
                                    return DropdownButton(
                                      iconEnabledColor: kPrimaryColor,
                                      items: _dropDownValues
                                          .map((value) => DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: const TextStyle(
                                                    color: kPrimaryColor),
                                              )))
                                          .toList(),
                                      onChanged: (value) {},
                                      isExpanded: false,
                                      value: selectedValue,
                                    );
                                  },
                                  stream: service.listenToPostsRealTime())),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            backgroundColor: kPrimaryColor,
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
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
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ValueListenableBuilder<List<String>>(
                              valueListenable: tasksNotifier,
                              builder: (_, values, __) {
                                if (values.isNotEmpty &&
                                    values.last != _dropDownValues.first) {
                                  return FutureBuilder(
                                      future: service.getPost(values.last),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<dynamic> snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Container(
                                              width: SizeConfig.screenWidth,
                                              height:
                                                  SizeConfig.screenHeight / 2,
                                              alignment: Alignment.center,
                                              child: Text("Fetching Data",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium));
                                        } else if (snapshot.connectionState ==
                                                ConnectionState.active ||
                                            snapshot.connectionState ==
                                                ConnectionState.done) {
                                          if (snapshot.hasData) {
                                            surveyDataSorce = AnswerDataSource(
                                                formData: snapshot.data);
                                            if (surveyDataSorce
                                                .rows.isNotEmpty) {
                                              return SfDataGrid(
                                                source: surveyDataSorce,
                                                columnWidthMode: ColumnWidthMode
                                                    .lastColumnFill,
                                                rowHeight: 65.0,
                                                columns: <GridColumn>[
                                                  GridColumn(
                                                      columnName: 'question_1',
                                                      label: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(16.0),
                                                          alignment:
                                                              Alignment.center,
                                                          child: const Text(
                                                            'Quiz Title',
                                                          ))),
                                                  GridColumn(
                                                      columnName: 'question_2',
                                                      label: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          alignment:
                                                              Alignment.center,
                                                          child: const Text(
                                                              'Date Answered'))),
                                                  GridColumn(
                                                      columnName: 'question_3',
                                                      label: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          alignment:
                                                              Alignment.center,
                                                          child: const Text(
                                                            'Question 3',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ))),
                                                  GridColumn(
                                                      columnName: 'question_4',
                                                      label: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          alignment:
                                                              Alignment.center,
                                                          child: const Text(
                                                              'Question 4'))),
                                                  GridColumn(
                                                      columnName: 'action',
                                                      label: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          alignment:
                                                              Alignment.center,
                                                          child: const Text(
                                                            'Action',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blueAccent),
                                                          ))),
                                                ],
                                              );
                                            } else {
                                              return Container(
                                                width: SizeConfig.screenWidth,
                                                height:
                                                    SizeConfig.screenHeight / 2,
                                                alignment: Alignment.center,
                                                child: Text("Answers not found",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium),
                                              );
                                            }
                                          } else if (snapshot.hasError) {
                                            return Container(
                                              width: SizeConfig.screenWidth,
                                              height:
                                                  SizeConfig.screenHeight / 2,
                                              alignment: Alignment.center,
                                              child: Text(
                                                  "Failed to fetch Quiz answers",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium),
                                            );
                                          }
                                        }
                                        return Container(
                                          width: SizeConfig.screenWidth,
                                          height: SizeConfig.screenHeight / 2,
                                          alignment: Alignment.center,
                                          child: Text(
                                              "State ${snapshot.connectionState}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium),
                                        );
                                      });
                                } else {
                                  return Container(
                                    width: SizeConfig.screenWidth,
                                    height: SizeConfig.screenHeight / 2,
                                    alignment: Alignment.center,
                                    child: Text("Answers not found",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                  );
                                }
                              })))))
        ],
      ),
    );
  }
}
