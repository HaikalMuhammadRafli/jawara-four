import 'package:intl/intl.dart';

class NumberHelpers {
  // Format currency: Rp 50,000
  static String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  // Format number with thousand separator: 1,000,000
  static String formatNumber(int number) {
    final formatter = NumberFormat('#,##0');
    return formatter.format(number);
  }

  // Parse currency string to int (remove Rp and dots)
  static int? parseCurrency(String currencyString) {
    try {
      final cleaned = currencyString
          .replaceAll('Rp', '')
          .replaceAll('.', '')
          .replaceAll(',', '')
          .trim();
      return int.tryParse(cleaned);
    } catch (e) {
      return null;
    }
  }

  // Format compact (1.5M, 50K, etc)
  static String formatCompact(int number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}M';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}Jt';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    }
    return number.toString();
  }

  // Format percentage: 75%
  static String formatPercentage(double percentage) {
    return '${percentage.toStringAsFixed(1)}%';
  }
}
