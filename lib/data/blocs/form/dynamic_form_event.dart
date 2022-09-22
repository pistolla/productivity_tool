import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';

class LoadFormEvent extends FormElementEvent {
  String documentId;
  int formNumber;
  LoadFormEvent({required this.documentId, required this.formNumber});
}

class ClearFormEvent extends FormElementEvent {}

class RequestFormDataEvent extends FormElementEvent {}

class ClearFormDataEvent extends FormElementEvent {}

class PostFormDataEvent extends FormElementEvent {
  String documentId;
  PostFormDataEvent({required this.documentId});
}
