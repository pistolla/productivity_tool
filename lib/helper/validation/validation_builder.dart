import 'package:flutter/material.dart';
import 'package:remotesurveyadmin/helper/validation/validators_util.dart';

typedef ValidationRuleCallback = String? Function(String? value, BuildContext context);

class ValidationBuilder {
  final List<ValidationRuleCallback> rules = [];

  ValidationBuilder add(ValidationRuleCallback validator) {
    return this..rules.add(validator);
  }

  ValidationBuilder isValidEmail() {
    return add(
      (text, context) => ValidatorsUtil.isValidEmail(text) ? null : "",
    );
  }

  ValidationBuilder isNotBlank() {
    return add(
      (text, context) => ValidatorsUtil.isNotBlank(text) ? null : "",
    );
  }

  ValidationBuilder isValidCardCvv() {
    return add(
      (text, context) => ValidatorsUtil.isNotBlank(text) &&
              ValidatorsUtil.isNotLessThan(text ?? '', 3) &&
              ValidatorsUtil.isNotLongerThan(text ?? '', 3)
          ? null
          : "",
    );
  }

  ValidationBuilder isValidCardExpiry() {
    return add((text, context) {
      final List<String> items = (text ?? '').split('/');
      final int nowMonth = DateTime.now().month;
      final int nowYear = DateTime.now().year;
      if (!ValidatorsUtil.isNotBlank(text)) {
        return "";
      } else if ([
        !ValidatorsUtil.isNotLessThan(text ?? '', 5),
        !ValidatorsUtil.isNotLongerThan(text ?? '', 5),
        items.length == 2 && ((int.tryParse(items[0]) ?? 12) > 12),
      ].any((element) => element)) {
        return "";
      } else if (items.length == 2 &&
          [
            (int.tryParse('20${items[1]}') ?? nowYear) < nowYear,
            ((int.tryParse('20${items[1]}') ?? nowYear) == nowYear && (int.tryParse(items[0]) ?? 12) < nowMonth)
          ].any((element) => element)) {
        return "";
      }
      return null;
    });
  }

  ValidationBuilder isValidCardNumber() {
    return add((text, context) {
      final String newText = (text ?? '').replaceAll(" ", "");
      if (!ValidatorsUtil.isNotBlank(newText)) {
        return "";
      } else if ([
        !ValidatorsUtil.isNotLessThan(newText, 16),
        !ValidatorsUtil.isNotLongerThan(newText, 16),
      ].any((element) => element)) {
        return "";
      }
      return null;
    });
  }

  String? build(String? text, BuildContext context) {
    for (final rule in rules) {
      final result = rule(text, context);
      if (result != null) {
        return result;
      }
    }
    return null;
  }
}
