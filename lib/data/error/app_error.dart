
import 'package:flutter/material.dart';

class AppError implements Exception {
  String error;

  AppError._(this.error);

  factory AppError.unknownFailure(String error) {
    return AppError._(error);
  }

  @override
  String toString() {
    return this.error;
  }

  localizedTitle(BuildContext context) {}

  localizedMessage(BuildContext context) {}
}