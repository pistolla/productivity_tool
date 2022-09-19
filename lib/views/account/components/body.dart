import 'package:remotesurveyadmin/config/constants.dart';
import 'package:remotesurveyadmin/data/blocs/user/user_bloc.dart';
import 'package:remotesurveyadmin/data/blocs/user/user_event.dart';
import 'package:remotesurveyadmin/data/blocs/user/user_state.dart';
import 'package:remotesurveyadmin/helper/date_formatter_util.dart';
import 'package:remotesurveyadmin/views/home/components/section_title.dart';
import 'package:remotesurveyadmin/widgets/adaptive/alert_dialog/adaptive_alert_dialog_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<UserBloc>().add(UserStarted());
    return SingleChildScrollView(
        child: BlocConsumer<UserBloc, UserState>(
            buildWhen: (previousState, state) {
              return state != previousState;
            },
            listener: (BuildContext context, state) {},
            builder: (context, state) {
              return state is UserLoading
                  ? Container(
                      child: CircularProgressIndicator(),
                      alignment: Alignment.topCenter,
                    )
                  : state is UserLoaded || state is UserUpdating
                      ? Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SectionTitle(
                                    title: "Personal Details",
                                    press: () {},
                                  ),
                                  ListTile(
                                    leading: Text("Full name"),
                                    title: Text(
                                      state.userModel.firstName +
                                          " " +
                                          state.userModel.lastName,
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                  ListTile(
                                    leading: Text("Email"),
                                    title: Text(state.userModel.email,
                                        textAlign: TextAlign.end),
                                  ),
                                  ListTile(
                                    leading: Text("Phone"),
                                    title: Text(state.userModel.phone!,
                                        textAlign: TextAlign.end),
                                  ),
                                  ListTile(
                                    leading: Text("Date of Registration"),
                                    title: Text(""+state
                                        .userModel.registrationDate!,
                                        textAlign: TextAlign.end),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SectionTitle(
                                    title: "Payment Details",
                                    press: () {},
                                  ),
                                  ListTile(
                                    leading: Text("Account name"),
                                    title: Text(
                                      state.userModel.firstName +
                                          " " +
                                          state.userModel.lastName,
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                  ListTile(
                                    leading: Text("Account no."),
                                    title: Text(""+state.userModel.phone!,
                                        textAlign: TextAlign.end),
                                  ),
                                  ListTile(
                                    leading: Text("Last Transaction Code"),
                                    title: Text("",
                                        textAlign: TextAlign.end),
                                  ),
                                  ListTile(
                                    leading: Text("Last Transaction Date"),
                                    title: Text(
                                        DateFormatterUtil()
                                            .format(date: DateTime.now()),
                                        textAlign: TextAlign.end),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SectionTitle(
                                    title: "Data Protection",
                                    press: () {},
                                  ),
                                  ListTile(
                                      leading: Text("Opt out?"),
                                      title: GestureDetector(
                                        child: Text(
                                          "delete",
                                          style:
                                              TextStyle(color: kPrimaryColor),
                                          textAlign: TextAlign.end,
                                        ),
                                        onTap: () {
                                          AdaptiveAlertDialogFactory.showOKAlert(
                                              context,
                                              title:
                                                  "Warning, your account will be deleted completely");
                                        },
                                      )),
                                ],
                              ),
                            )
                          ],
                        )
                      : Container(
                          alignment: Alignment.topCenter,
                          child: Text('No data found',
                              style: Theme.of(context).textTheme.bodyLarge));
            }));
  }
}
