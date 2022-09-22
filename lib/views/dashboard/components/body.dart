import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remotesurveyadmin/api/firestore_service.dart';
import 'package:remotesurveyadmin/config/size_config.dart';
import 'package:remotesurveyadmin/helper/date_formatter_util.dart';
import 'package:remotesurveyadmin/models/form_model.dart';
import 'package:remotesurveyadmin/models/survey_data_source.dart';
import 'package:remotesurveyadmin/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remotesurveyadmin/views/home/home_view.dart';

class Body extends StatelessWidget {
  List<FormModel> surveys = <FormModel>[];
  late FormDataSource surveyDataSorce;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: kPrimaryColor,
    ));
    surveyDataSorce = FormDataSource(formData: surveys);
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
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Stack(fit: StackFit.expand, children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 5.0),
                      child: const Icon(Icons.question_answer_outlined,
                          size: 65, color: Colors.white24)),
                ),
                StreamBuilder(
                    stream: service.listenToNotificationsRealTime(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.active ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        if (snapshot.hasData) {
                          var items = snapshot.data as List;
                          return Align(
                              alignment: Alignment.center,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 5.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Status: ${snapshot.connectionState}",
                                        style: const TextStyle(
                                            color: Colors.white24,
                                            fontSize: 14)),
                                  ],
                                ),
                              ));
                        } else if (snapshot.hasError) {
                          return Align(
                              alignment: Alignment.center,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 5.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Text("Status: Failed",
                                        style: TextStyle(
                                            color: Colors.white24,
                                            fontSize: 14)),
                                  ],
                                ),
                              ));
                        }
                      }
                      return Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Status: ${snapshot.connectionState}",
                                    style: const TextStyle(
                                        color: Colors.white24, fontSize: 14)),
                              ],
                            ),
                          ));
                    }),
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
                        children: const [],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            backgroundColor: kPrimaryColor,
            leading: const Text(
              "QUIZ APP",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w200),
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
                  width: SizeConfig.screenWidth,
                  alignment: Alignment.topCenter,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.blueAccent.shade100),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.all(50)),
                                    overlayColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) {
                                      return states
                                              .contains(MaterialState.pressed)
                                          ? kPrimaryColor
                                          : null;
                                    }),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: const BorderSide(
                                                color: kPrimaryColor)))),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, HomeView.routeName);
                                },
                                child: const Icon(
                                  Icons.file_present,
                                  size: 65.0,
                                ),
                              ),
                              const Text("QUIZZES",
                                  style: TextStyle(fontSize: 15))
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.greenAccent.shade100),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.all(50)),
                                    overlayColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) {
                                      return states
                                              .contains(MaterialState.pressed)
                                          ? kPrimaryColor
                                          : null;
                                    }),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: const BorderSide(
                                                color: kPrimaryColor)))),
                                onPressed: () {},
                                child: const Icon(
                                  Icons.timer,
                                  size: 65.0,
                                ),
                              ),
                              const Text("TODOs",
                                  style: TextStyle(fontSize: 15))
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.redAccent.shade100),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.all(50)),
                                    overlayColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) {
                                      return states
                                              .contains(MaterialState.pressed)
                                          ? kPrimaryColor
                                          : null;
                                    }),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: const BorderSide(
                                                color: kPrimaryColor)))),
                                onPressed: () {},
                                child: const Icon(
                                  Icons.date_range_sharp,
                                  size: 65.0,
                                ),
                              ),
                              const Text("SCHEDULER",
                                  style: TextStyle(
                                      fontSize: 15, color: kTextColor))
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.yellowAccent.shade100),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.all(50)),
                                    overlayColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) {
                                      return states
                                              .contains(MaterialState.pressed)
                                          ? kPrimaryColor
                                          : null;
                                    }),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: const BorderSide(
                                                color: kPrimaryColor)))),
                                onPressed: () {},
                                child: const Icon(
                                  Icons.settings_applications,
                                  size: 65.0,
                                ),
                              ),
                              const Text("SETTINGS",
                                  style: TextStyle(fontSize: 15))
                            ],
                          )
                        ],
                      )
                    ],
                  ))),
          const SliverToBoxAdapter(
              child: SizedBox(
            height: 40,
          )),
          StreamBuilder(
              stream: service.listenToNotificationsRealTime(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  if (snapshot.hasData) {
                    var items = snapshot.data as List;
                    return SliverToBoxAdapter(
                        child: Column(
                      children: [
                        ...items.map((e) {
                          var val = DateFormatterUtil().serverFormattedDate(
                              DateTime.parse(
                                  e.date_created.toDate().toString()));
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 70,
                                color: Colors.white,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      color: Colors.blueAccent.shade100,
                                      width: 70,
                                      height: 70,
                                      child: const Icon(Icons.file_present,
                                          color: Colors.white),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${e.message}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          Text(val,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall)
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios,
                                        color: Colors.white24),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                      ],
                    ));
                  } else if (snapshot.hasError) {
                    return SliverToBoxAdapter(
                        child: Container(
                            width: SizeConfig.screenWidth,
                            height: SizeConfig.screenHeight / 3,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5.0),
                            child: const Text("Failed to fetch notifications",
                                style: TextStyle(
                                    color: kTextColor, fontSize: 18))));
                  }
                }
                return SliverToBoxAdapter(
                    child: Container(
                        width: SizeConfig.screenWidth,
                        height: SizeConfig.screenHeight / 3,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        child: const Text("Waiting...",
                            style:
                                TextStyle(color: kTextColor, fontSize: 18))));
              }),
        ],
      ),
    );
  }
}
