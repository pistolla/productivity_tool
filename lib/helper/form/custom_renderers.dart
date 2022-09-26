import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart';
import 'package:remotesurveyadmin/helper/form/custom_form_group_renderer.dart';

import 'custom_dropdown_button_renderer.dart';

List<FormElementRenderer<FormElement>> getFormRenderers() {
  return [
    DefaultFormRenderer(),
    CustomFormGroupRenderer(),
    CheckBoxRenderer(),
    LabelRenderer(),
    TextFieldRenderer(),
    RadioButtonGroupRenderer(),
    ReactiveRadioButtonRenderer(),
    CustomDropdownButtonRenderer(),
    SingleSelectChipGroupRenderer(),
    ReactiveSingleSelectChipChoiceRenderer(),
    MultiSelectChipChoiceRenderer(),
    MultiSelectChipGroupRenderer(),
    ReactiveDateRenderer(),
    DateRangeRenderer(),
    SliderRenderer(),
  ];
}
