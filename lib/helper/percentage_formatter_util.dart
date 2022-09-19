import 'package:intl/intl.dart';

class PercentageFormatterUtil {

  final NumberFormat numberFormat = NumberFormat.decimalPercentPattern(
    decimalDigits: 2,
  );

  String format({
    required double value,
    int decimalDigits = 2,
  }) {
    if (decimalDigits != 2) {
      return NumberFormat.decimalPercentPattern(
        decimalDigits: decimalDigits,
      ).format(value / 100.0);
    }
    return numberFormat.format(value.abs() / 100.0);
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
}
