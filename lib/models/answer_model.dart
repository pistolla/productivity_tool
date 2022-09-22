import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class AnswerModel {
  String user_id;
  Timestamp published_on;
  String answer;

  AnswerModel(
      {required this.user_id,
      required this.published_on,
      required this.answer});

  factory AnswerModel.fromMap(Map<String, dynamic> data) {
    return AnswerModel(
        user_id: data["user_id"],
        published_on: data["published_on"],
        answer: data["answer"]);
  }

  Map getQuestion(int position) {
    Map<String, dynamic> decodedMap = json.decode(answer);
    var dataMap = {};
    decodedMap.forEach((key, value) {
      if (value is Map) {
        int count = 0;
        value.forEach((index, data) {
          if (count == position) {
            dataMap = data;
          }
          count++;
        });
      }
    });
    return dataMap;
  }
}
