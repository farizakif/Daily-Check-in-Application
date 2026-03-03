import 'package:intl/intl.dart';

class AppDateUtils {
  const AppDateUtils._();

  /// Get a DateTime at midnight (00:00:00)
  static DateTime dateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  /// Check if two dates are the same day
  static bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Format date as "Monday, 03 March 2026"
  static String formatFullDate(DateTime dateTime) {
    return DateFormat('EEEE, d MMMM y').format(dateTime);
  }

  /// Format date as "Mon, 03 Mar 2026"
  static String formatHistoryDate(DateTime dateTime) {
    return DateFormat('EEE, d MMM y').format(dateTime);
  }

  /// Format time as "02:30 PM"
  static String formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  /// Format date key as "2026-03-03"
  static String formatDateKey(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  /// Get list of last 30 days in descending order
  static List<DateTime> last30Days() {
    final now = DateTime.now();
    return List.generate(
      30,
      (index) => DateTime(now.year, now.month, now.day).subtract(
        Duration(days: index),
      ),
    );
  }

  /// Get a motivational greeting based on time of day
  static String dailyGreeting(DateTime dateTime) {
    final hour = dateTime.hour;
    if (hour < 12) {
      return 'Good morning, have a good day!';
    } else if (hour < 18) {
      return 'Good afternoon, keep the momentum.';
    } else {
      return 'Good evening, finish the day well.';
    }
  }

  /// Get a motivational quote based on weekday
  static String motivationalQuoteForWeekday(DateTime dateTime) {
    switch (dateTime.weekday) {
      case DateTime.monday:
        return 'Small consistent steps compound into big outcomes.';
      case DateTime.tuesday:
        return 'Discipline today becomes freedom tomorrow.';
      case DateTime.wednesday:
        return 'Progress over perfection — check in and move on.';
      case DateTime.thursday:
        return 'Your future self is investing in this moment.';
      case DateTime.friday:
        return 'End the week the way you want to remember it.';
      case DateTime.saturday:
        return 'Rest is part of the strategy, not an escape.';
      case DateTime.sunday:
      default:
        return 'Reflect, reset, and recommit to your goals.';
    }
  }
}
