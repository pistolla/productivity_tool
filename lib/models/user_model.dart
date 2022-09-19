import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? avatar;
  String email;
  String firstName;
  String lastName;
  String? phone;
  String? registrationDate;
  String? names;
  String? id;

  UserModel(
      {required this.email,
      required this.firstName,
      required this.lastName,
      this.avatar,
      required this.phone,
      this.registrationDate,
      this.names,
      this.id});

  String get fullName => names ?? '$firstName $lastName';

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
        avatar: data["avatar"],
        email: data["email"],
        firstName: data["firstName"],
        lastName: data["lastName"],
        names: data["names"],
        phone: data["phone"],
        id: data["id"]
    );
  }

  @override
  String toString() {
    return {
      "avatar": avatar,
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "names": names,
      "phone": phone,
      "id": id
    }.toString();
  }

  factory UserModel.fromSnapShot(DocumentSnapshot  data) {
    return UserModel(
        id: data.id,
        avatar: data["avatar"],
        email: data["email"],
        firstName: data["firstName"],
        lastName: data["lastName"],
        names: data["names"],
        phone: data["phone"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "avatar": avatar,
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "names": names,
      "phone": phone,
      "id": id
    };
  }
}
