import 'package:intl/intl.dart';

class DateHelpers {
  // Format: 15 October 2025
  static String formatDate(DateTime date) {
    return DateFormat('d MMMM yyyy').format(date);
  }

  // Format: 15 Oct 2025
  static String formatDateShort(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }

  // Format: 15/10/2025
  static String formatDateSlash(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Format: 15 October 2025, 14:30
  static String formatDateTime(DateTime date) {
    return DateFormat('d MMMM yyyy, HH:mm').format(date);
  }

  // Format: 14:30
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  // Format: Monday, 15 October 2025
  static String formatDateLong(DateTime date) {
    return DateFormat('EEEE, d MMMM yyyy').format(date);
  }

  // Parse date from string (dd/MM/yyyy)
  static DateTime? parseDate(String dateString) {
    try {
      return DateFormat('dd/MM/yyyy').parse(dateString);
    } catch (e) {
      return null;
    }
  }

  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  // Get relative time (Today, Yesterday, 2 days ago, etc)
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks weeks ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months months ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years years ago';
    }
  }
}
