import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static DateTime nowUtc() => DateTime.now().toUtc();

  static DateTime toTbilisiTime(DateTime utcTime) {
    return utcTime.toLocal();
  }

  static DateTime toUtc(DateTime localTime) {
    return localTime.toUtc();
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date.toLocal());
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date.toLocal());
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm').format(date.toLocal());
  }

  static String formatDateForApi(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formatTimeRange(DateTime start, DateTime end) {
    return '${formatTime(start)} - ${formatTime(end)}';
  }

  static String formatDayOfWeek(DateTime date) {
    return DateFormat('EEEE').format(date.toLocal());
  }

  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date.toLocal());
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  static List<DateTime> generateTimeSlots({
    required DateTime dayStart,
    required DateTime dayEnd,
    required int durationMinutes,
    required int bufferMinutes,
  }) {
    final slots = <DateTime>[];
    var current = dayStart;
    while (current.add(Duration(minutes: durationMinutes)).isBefore(dayEnd) ||
        current.add(Duration(minutes: durationMinutes)).isAtSameMomentAs(dayEnd)) {
      slots.add(current);
      current = current.add(Duration(minutes: durationMinutes + bufferMinutes));
    }
    return slots;
  }
}
