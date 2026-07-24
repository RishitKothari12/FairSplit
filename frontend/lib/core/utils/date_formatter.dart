import 'package:intl/intl.dart';

class DateFormatter {
  static String format(DateTime date) {
    final localDate = date.toLocal();

    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final yesterday = today.subtract(
      const Duration(days: 1),
    );

    final target = DateTime(
      localDate.year,
      localDate.month,
      localDate.day,
    );

    final time = DateFormat('h:mm a').format(localDate);

    if (target == today) {
      return "Today • $time";
    }

    if (target == yesterday) {
      return "Yesterday • $time";
    }

    return "${DateFormat('d MMM').format(localDate)} • $time";
  }
}