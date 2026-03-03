import 'package:intl/intl.dart';

class DateUtilsHelper {
  static String formatFullDate(DateTime dateTime) {
    return DateFormat('EEEE, d MMMM y').format(dateTime);
  }

  static String formatHistoryDate(DateTime dateTime) {
    return DateFormat('EEE, d MMM y').format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  static String formatDateKey(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  static List<DateTime> last30Days() {
    final now = DateTime.now();
    return List.generate(
      30,
      (index) => DateTime(now.year, now.month, now.day).subtract(
        Duration(days: index),
      ),
    );
  }

  static String dailyGreeting(DateTime dateTime) {
    final hour = dateTime.hour;
    if (hour < 12) {
      return 'Good morning, have a good day !';
    } else if (hour < 18) {
      return 'Good afternoon, keep the momentum.';
    } else {
      return 'Good evening, finish the day well.';
    }
  }

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

