import "package:campus_mart/Model/NotificationModel.dart";
import "package:intl/intl.dart";

String timeAgo(DateTime pastTime) {
  Duration difference = DateTime.now().difference(pastTime);

  if (difference.inMinutes < 1) {
    return "just now";
  } else if (difference.inHours < 1) {
    int minutes = difference.inMinutes;
    return "$minutes ${_pluralize(minutes, 'minute')} ago";
  } else if (difference.inDays < 1) {
    int hours = difference.inHours;
    return "$hours ${_pluralize(hours, 'hour')} ago";
  } else if (difference.inDays < 7) {
    int days = difference.inDays;
    return "$days ${_pluralize(days, 'day')} ago";
  } else if (difference.inDays < 30) {
    int weeks = (difference.inDays / 7).floor();
    return "$weeks ${_pluralize(weeks, 'week')} ago";
  } else if (difference.inDays < 365) {
    int months = (difference.inDays / 30).floor();
    return "$months ${_pluralize(months, 'month')} ago";
  } else {
    int years = (difference.inDays / 365).floor();
    return "$years ${_pluralize(years, 'year')} ago";
  }
}

String _pluralize(int count, String unit) {
  return count == 1 ? unit : '${unit}s';
}

String normalizeAmount(int amount) {
  final formatter = NumberFormat("#,###");
  return formatter.format(amount);
}

String getDateDescription(DateTime date) {
  DateTime now = DateTime.now();
  Duration difference = now.difference(date);

  if (isSameDay(now, date)) {
    return 'Today';
  } else if (difference.inDays == 1) {
    return 'Yesterday';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays < 30) {
    int weeksAgo = (difference.inDays / 7).floor();
    return '$weeksAgo weeks ago';
  } else {
    int monthsAgo = (difference.inDays / 30).floor();
    return '$monthsAgo months ago';
  }
}

String getDateDescriptionChat(DateTime date) {
  DateTime now = DateTime.now();
  Duration difference = now.difference(date);
  DateFormat timeFormat = DateFormat('HH:mm');
  DateFormat weekdayFormat = DateFormat('EEEE');
  DateFormat fullDateFormat = DateFormat('dd/MM/yyyy');

  if (isSameDay(now, date)) {
    return timeFormat.format(date);
  } else if (difference.inDays == 1) {
    return 'Yesterday';
  } else if (difference.inDays < 7) {
    return weekdayFormat.format(date);
  } else {
    return fullDateFormat.format(date);
  }
}

// Helper function to check if two dates are on the same day
bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
}


int compareTimestamps(NotificationModel a, NotificationModel b) {
  // Compare timestamps based on years, months, days, hours, and minutes
  if (a.createdAt!.year != b.createdAt!.year) {
    return a.createdAt!.year.compareTo(b.createdAt!.year);
  } else if (a.createdAt!.month != b.createdAt!.month) {
    return a.createdAt!.month.compareTo(b.createdAt!.month);
  } else if (a.createdAt!.day != b.createdAt!.day) {
    return a.createdAt!.day.compareTo(b.createdAt!.day);
  } else if (a.createdAt!.hour != b.createdAt!.hour) {
    return a.createdAt!.hour.compareTo(b.createdAt!.hour);
  } else if (a.createdAt!.minute != b.createdAt!.minute) {
    return a.createdAt!.minute.compareTo(b.createdAt!.minute);
  } else {
    return 0; // Timestamps are equal
  }
}