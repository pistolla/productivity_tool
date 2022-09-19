import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remotesurveyadmin/config/styles/colors/app_colors.dart';

class CurrencyFormatterUtil {
  final NumberFormat numberFormat = NumberFormat.currency(
    symbol: 'KES ',
  );

  String format({
    required double value,
  }) {
    return numberFormat.format(value);
  }

  String formatWithChangePrefix({
    required double value,
  }) {
    if (value.isNegative) {
      return format(
        value: value,
      );
    }
    return '+ ${format(value: value)}';
  }

  Color changeColor({
    required double value,
  }) {
    return value.isNegative ? AppColors.error300 : AppColors.success100;
  }
}
