import 'package:intl/intl.dart';

class DateFormatterUtil {

  String format({
    required DateTime? date,
    String? pattern,
  }) {
    return date != null ? DateFormat(pattern).format(date) : "";
  }

  String? formatDay({
    required DateTime? date,
  }) {
    return date != null ? DateFormat.EEEE().format(date) : null;
  }

  String serverFormattedDate(DateTime? date) {
    return date != null ? DateFormat("dd-MM-yyyy H:mm:s", "en_US").format(date) : "";
  }

  String formatInterval({
    required DateTime? from,
    required DateTime? to,
  }) {
    if (from == null || to == null) {
      return '';
    }
    final DateFormat dateFormat = DateFormat.MMMMd();
    final String fromString;
    if (from.year != to.year) {
      fromString = DateFormat.yMMMMd().format(from);
    } else {
      fromString = dateFormat.format(from);
    }
    final String toString;
    if (from.year == to.year && from.month == to.month) {
      toString = DateFormat.d().format(to);
    } else {
      if (from.year != to.year) {
        toString = DateFormat.yMMMMd().format(to);
      } else {
        toString = dateFormat.format(to);
      }
    }
    return '$fromString - $toString';
  }

  String formatTitleInterval({
    required DateTime? from,
    required DateTime? to,
  }) {
    if (from == null || to == null) {
      return '';
    }
    if (from.month == to.month && from.year == to.year) {
      return DateFormat.yMMMM().format(from);
    } else if (from.month != to.month && from.year == to.year) {
      return '${DateFormat.MMM().format(from)} - ${DateFormat.yMMM().format(to)}';
    } else {
      return '${DateFormat.yM().format(from)} - ${DateFormat.yM().format(to)}';
    }
  }

  String formatContentInterval({
    required DateTime? from,
    required DateTime? to,
  }) {
    if (from == null || to == null) {
      return '';
    }
    final DateFormat dateFormat = DateFormat.d();

    return '${dateFormat.format(from)} - ${dateFormat.format(to)}';
  }

  DateTime getStartWeekDate(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  DateTime getStopWeekDate(DateTime date) {
    return date.add(Duration(days: DateTime.daysPerWeek - date.weekday));
  }

  DateTime getStartMonthDate(DateTime date) {
    return new DateTime(date.year, date.month, 1);
  }

  DateTime getStopMonthDate(DateTime date) {
    return (date.month < 12) ? new DateTime(date.year, date.month + 1, 0) : new DateTime(date.year + 1,1,0);
  }

  DateTime getStartYearDate(DateTime date) {
    return new DateTime(date.year, 1, 1);
  }

  DateTime getStopYearDate(DateTime date) {
    return new DateTime(date.year, 11, 31);
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    final dateFormat = DateFormat("yyyy-MM-dd");
    final first = dateFormat.format(date1);
    final second = dateFormat.format(date2);

    return first == second;
  }

  bool isSameWeek(DateTime date1, DateTime date2) {
    return weekNumber(date1) == weekNumber(date2);
  }

  bool isSameMonth(DateTime date1, DateTime date2) {

    return date1.month == date2.month;
  }

  int numOfWeeks(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
    return ((dayOfDec28 = dec28.weekday + 10) / 7).floor();
  }

  int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    int woy = ((dayOfYear - date.weekday + 10) / 7).floor();
    if (woy < 1){
      woy = numOfWeeks(date.year - 1);
    } else if (woy > numOfWeeks(date.year)){
      woy = 1;
    }
    return woy;
  }

}
