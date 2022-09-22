import 'package:bloc/bloc.dart';
import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart';
import 'package:remotesurveyadmin/views/dynamic_form/body/transition_form_builder.dart';
import 'package:remotesurveyadmin/views/dynamic_form/body/custom_form_manager.dart';
import 'dynamic_form_event.dart';
import 'dynamic_form_state.dart';

class DynamicFormBloc extends Bloc<FormElementEvent, DynamicFormState> {
  static const Duration transitionDuration = Duration(milliseconds: 600);
  final FormBuilder formBuilder;
  final TransitionFormBuilder transitionFormBuilder;

  late FormData formData;
  FormManager? formManager;

  DynamicFormBloc(this.formBuilder, this.transitionFormBuilder) : super(DynamicFormState());

  @override
  Stream<DynamicFormState> mapEventToState(FormElementEvent event) async* {
    CustomFormManager manager = CustomFormManager();
    if (event is LoadFormEvent) {
      String json = await manager.initialize(event.documentId, event.formNumber);
      var oldForm = formManager?.form;
      formData = formBuilder.build(json);
      formManager = ExplicitFormManager(formData: formData);
      DynamicFormState currentState = state;
      if (oldForm != null) {
        var transitionForm = transitionFormBuilder.buildTranstionForm(
            oldForm as Form, formManager!.form as Form);
        currentState = state.copyWith(
            isInTransition: true,
            isValid: true,
            form: transitionForm,
            selectedForm: event.formNumber);
        yield currentState;
        await Future.delayed(transitionDuration);
      }

      yield currentState.copyWith(
          isInTransition: false,
          isValid: formManager!.isFormValid,
          form: formManager!.form as Form?,
          selectedForm: event.formNumber);
      return;
    }

    if (event is ClearFormEvent) {
      formManager!.resetForm();
      yield state.copyWith(
        isInTransition: false,
        isValid: formManager!.isFormValid,
        form: formManager!.form as Form?,
      );
      return;
    }

    if (event is RequestFormDataEvent) {
      yield state.copyWith(
          isInTransition: false,
          isValid: formManager!.isFormValid,
          form: formManager!.form as Form?,
          resultProperties: formManager!.getFormProperties());
      return;
    }

    if (event is ChangeValueEvent) {
      formManager!.changeValue(
        value: event.value,
        elementId: event.elementId,
        propertyName: event.propertyName,
        ignoreLastChange: event.ignoreLastChange,
      );
      yield state.copyWith(isValid: formManager!.isFormValid);
    }
  }
}
