import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('MMM d, yyyy • h:mm a');
    return formatter.format(dateTime);
  }

  static String formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('MMM d, yyyy');
    return formatter.format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('h:mm a');
    return formatter.format(dateTime);
  }
}
