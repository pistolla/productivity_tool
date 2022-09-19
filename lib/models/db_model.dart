abstract class DBModel {
  DBModel fromJson(Map<String, Object?> json);
  Map<String, Object?> toJson();
  DBModel copy(Map<String, dynamic> args);
  String getTable();
  List<String> getFields();
  int getId();
}