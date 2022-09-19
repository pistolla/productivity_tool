import 'dart:convert';

class Response {
  final int status;
  final String statusDesc;
  final Map<String, dynamic> data;

  const Response(
      {required this.status, required this.statusDesc, required this.data});

  factory Response.fromRawJson(String jsonStr) {
    Map<String, dynamic> values = new Map<String, dynamic>.from(json.decode(jsonStr));

    return Response.fromMap(values);
  }

  factory Response.fromMap(Map<String, dynamic> json) {
    return Response(status: json['status'], statusDesc: json['statusDesc'], data: json['data'] != null ? json['data'] : new Map<String, dynamic>());
  }
}
