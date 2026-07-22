// lib/core/utils/date_formatter.dart

import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final _dateFormatter = DateFormat('dd MMMM yyyy', 'id_ID');
  static final _dateTimeFormatter = DateFormat('dd MMM yyyy, HH:mm', 'id_ID');
  static final _timeFormatter = DateFormat('HH:mm', 'id_ID');
  static final _shortDateFormatter = DateFormat('dd/MM/yyyy');

  static String formatDate(DateTime date) => _dateFormatter.format(date);
  static String formatDateTime(DateTime date) =>
      _dateTimeFormatter.format(date);
  static String formatTime(DateTime date) => _timeFormatter.format(date);
  static String formatShort(DateTime date) => _shortDateFormatter.format(date);

  static String formatFromString(String? dateStr) {
    if (dateStr == null) return '-';
    try {
      return formatDate(DateTime.parse(dateStr));
    } catch (_) {
      return dateStr;
    }
  }
}
