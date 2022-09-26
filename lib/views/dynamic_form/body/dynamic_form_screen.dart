import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as flutter;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remotesurveyadmin/api/firestore_service.dart';
import 'package:remotesurveyadmin/data/blocs/form/dynamic_form_bloc.dart';
import 'package:remotesurveyadmin/data/blocs/form/dynamic_form_event.dart';
import 'package:remotesurveyadmin/data/blocs/form/dynamic_form_state.dart';
import 'package:remotesurveyadmin/models/notification_model.dart';
import 'package:remotesurveyadmin/storage/session.dart';
import 'package:remotesurveyadmin/views/dynamic_form/body/dynamic_form_container.dart';

class DynamicFormScreen extends StatelessWidget {
  final String documentId;
  final int formNumber;
  final String title;

  const DynamicFormScreen(
      {super.key,
      required this.documentId,
      required this.formNumber,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: BlocListener<DynamicFormBloc, DynamicFormState>(
            listener: (context, state) {
              if (state.resultProperties.isNotEmpty) {
                _displayDialog(context, state.resultProperties);
              }
            },
            child: BlocBuilder<DynamicFormBloc, DynamicFormState>(
              builder: (context, state) {
                return Column(
                  children: [
                    DynamicFormContainer(
                        documentId: documentId, formNumber: formNumber),
                    if (!state.isInTranstion)
                      DynamicFormButtonRow(title, documentId, state)
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _displayDialog(BuildContext context,
      List<FormPropertyValue> resultPropertyValues) async {
    var bloc = BlocProvider.of<DynamicFormBloc>(context);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const flutter.Text('Preview JSON'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300.0,
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              //map List of our data to the ListView
              children: resultPropertyValues
                  .map((riv) => flutter.Text('${riv.id}: ${riv.value}'))
                  .toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const flutter.Text('Cancel', style: TextStyle(color: Colors.redAccent)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const flutter.Text('Post to Firestore'),
              onPressed: () {
                bloc.add(PostFormDataEvent(documentId: documentId));
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}

class DynamicFormButtonRow extends StatelessWidget {
  final DynamicFormState state;
  final String documentId;
  final String title;

  const DynamicFormButtonRow(
    this.title,
    this.documentId,
    this.state, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<DynamicFormBloc>(context);
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        OutlinedButton(
          child: Row(
            children: const <Widget>[
              flutter.Text("Cancel"),
              SizedBox(width: 10),
              Icon(Icons.cancel, color: Colors.red),
            ],
          ),
          onPressed: () {
            Session session = Session();
            session.getUserID().then((userId) {
              session.getUsername().then((value) {
                var message =
                    "user has quit filing form $title ";
                var timestamp = Timestamp.fromDate(DateTime.now());
                var user_id = userId;
                var reference = documentId;

                FirestoreService service = FirestoreService();
                service.createNotification(NotificationModel(
                    id: '',
                    message: message,
                    date_created: timestamp,
                    reference: reference,
                    user_id: user_id));
              });
            });
            Navigator.pop(context);
          },
        ),
        const SizedBox(width: 10),
        OutlinedButton(
          child: Row(
            children: const <Widget>[
              flutter.Text("Clear"),
              SizedBox(width: 10),
              Icon(Icons.clear_all, color: Colors.red),
            ],
          ),
          onPressed: () {
            bloc.add(ClearFormEvent());
          },
        ),
        const SizedBox(width: 10),
        OutlinedButton(
          onPressed: state.isValid
              ? () {
                  bloc.add(RequestFormDataEvent());
                }
              : null,
          child: Row(
            children: <Widget>[
              const flutter.Text("Ok"),
              const SizedBox(width: 10),
              Icon(
                Icons.check_circle,
                color: state.isValid ? Colors.green : Colors.black26,
              ),
            ],
          ),
        )
      ],
    );
  }
}
