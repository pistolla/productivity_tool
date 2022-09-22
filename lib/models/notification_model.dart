import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String id;
  String message;
  Timestamp date_created;
  String reference;
  String user_id;

  NotificationModel(
      {required this.id,
      required this.message,
        required this.date_created,
      required this.reference,
      required this.user_id});

  factory NotificationModel.fromSnapShot(DocumentSnapshot snapshot) {
    return NotificationModel(
        id: snapshot.id,
        message: snapshot["message"],
        date_created: snapshot["date_created"],
        reference: snapshot["reference"],
        user_id: snapshot["user_id"]);
  }
}
