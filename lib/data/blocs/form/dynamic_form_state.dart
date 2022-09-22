import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart';
import 'package:meta/meta.dart';

@immutable
class DynamicFormState {
  final Form? form;

  final bool isInTranstion;
  final int selectedForm;
  final bool isValid;
  final List<FormPropertyValue> resultProperties;
  bool get isEmpty => form!.children.isEmpty;

  const DynamicFormState(
      {this.form,
        this.isInTranstion = false,
        this.isValid = false,
        this.selectedForm = 0,
        this.resultProperties = const []});

  DynamicFormState copyWith(
      {Form? form, bool? isInTransition, bool? isValid, int? selectedForm,List<FormPropertyValue>? resultProperties}) {
    return DynamicFormState(
        form: form ?? this.form,
        isInTranstion: isInTransition ?? isInTranstion,
        isValid: isValid ?? this.isValid,
        selectedForm: selectedForm ?? this.selectedForm,
        resultProperties: resultProperties ?? this.resultProperties);
  }
}
