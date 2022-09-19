import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart';
import '../../../views/dynamic_form/body/custom_form_manager.dart';
import 'dynamic_form_event.dart';
import 'dynamic_form_state.dart';

class DynamicFormBloc extends Bloc<FormElementEvent, DynamicFormState> {
  static const Duration transitionDuration = Duration(milliseconds: 600);
  CustomFormManager formManager;

  DynamicFormBloc(this.formManager) : super(DynamicFormState());

  @override
  Stream<DynamicFormState> mapEventToState(FormElementEvent event) async* {
    if (event is LoadFormEvent) {
      yield state.copyWith(isLoading: true);

      await Future.delayed(const Duration(seconds: 1));
      var json =
          await rootBundle.loadString('assets/test_form1.json', cache: false);
      formManager.init(content: json, parsers: getDefaultParserList());

      yield state.copyWith(
          isLoading: false,
          isValid: formManager.isFormValid,
          form: formManager.form as Form?);
      return;
    }

    if (event is ClearFormEvent) {
      formManager.resetForm();
      yield state.copyWith(
          isLoading: false,
          isValid: formManager.isFormValid,
          form: formManager.form as Form?);
      return;
    }

    if (event is RequestFormDataEvent) {
      yield state.copyWith(
          isLoading: false,
          isValid: formManager.isFormValid,
          form: formManager.form as Form?,
          resultProperties: formManager.getFormProperties());
      return;
    }

    if (event is ClearFormDataEvent) {
      yield state.copyWith(
          isLoading: false,
          isValid: formManager.isFormValid,
          form: formManager.form as Form?,
          resultProperties: []);
      return;
    }

    if (event is ChangeValueEvent) {
      formManager.changeValue(
        value: event.value,
        elementId: event.elementId,
        propertyName: event.propertyName,
        ignoreLastChange: event.ignoreLastChange,
      );
      var isValid = formManager.isFormValid;
      //No need to emit new state every time, because reactive renderers already listen to the changes.
      if (state.isValid != isValid) {
        yield state.copyWith(isValid: isValid);
      }
    }
  }
}
