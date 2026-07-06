import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  /// "₹1,23,456.50" — Indian number grouping (lakh/crore) with 2 decimals.
  static String formatINR(double amount) {
    final isNegative = amount < 0;
    final parts = amount.abs().toStringAsFixed(2).split('.');
    final wholePart = parts[0];
    final decimalPart = parts[1];

    String formattedWhole;
    if (wholePart.length <= 3) {
      formattedWhole = wholePart;
    } else {
      final lastThree = wholePart.substring(wholePart.length - 3);
      final rest = wholePart.substring(0, wholePart.length - 3);
      final buffer = StringBuffer();
      for (var i = 0; i < rest.length; i++) {
        final posFromEnd = rest.length - i;
        buffer.write(rest[i]);
        if (posFromEnd > 1 && posFromEnd.isOdd) {
          buffer.write(',');
        }
      }
      formattedWhole = '$buffer,$lastThree';
    }

    return '${isNegative ? '-' : ''}₹$formattedWhole.$decimalPart';
  }

  /// "₹1.2L", "₹45K", "₹999" based on magnitude.
  static String formatINRCompact(double amount) {
    final isNegative = amount < 0;
    final absAmount = amount.abs();
    final prefix = isNegative ? '-₹' : '₹';

    if (absAmount >= 100000) {
      return '$prefix${_trimTrailingZero(absAmount / 100000)}L';
    }
    if (absAmount >= 1000) {
      return '$prefix${_trimTrailingZero(absAmount / 1000)}K';
    }
    return '$prefix${absAmount.toStringAsFixed(0)}';
  }

  static String _trimTrailingZero(double value) {
    final rounded = (value * 10).round() / 10;
    if (rounded == rounded.roundToDouble()) {
      return rounded.toStringAsFixed(0);
    }
    return rounded.toStringAsFixed(1);
  }

  /// "2 min ago", "1 hr ago", "Yesterday", "01 Jul 2026"
  static String formatRelativeTime(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    if (diff.inDays == 1) return 'Yesterday';
    return formatDate(dateTime);
  }

  /// "01 Jul 2026"
  static String formatDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  /// "10:30 AM"
  static String formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  /// "01 Jul 2026 · 10:30 AM"
  static String formatDateTime(DateTime dateTime) {
    final date = DateFormat('dd MMM yyyy').format(dateTime);
    final time = DateFormat('hh:mm a').format(dateTime);
    return '$date · $time';
  }

  /// "+91 XXXXX 43210" — masks the first 5 digits of the local number.
  static String maskPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    final local = digits.length > 10
        ? digits.substring(digits.length - 10)
        : digits;
    if (local.length < 10) return phone;
    return '+91 XXXXX ${local.substring(5)}';
  }

  /// "xxxxxxxx@upi" — masks everything before the '@'.
  static String maskUpi(String upiId) {
    final atIndex = upiId.indexOf('@');
    if (atIndex <= 0) return upiId;
    return '${'x' * atIndex}${upiId.substring(atIndex)}';
  }
}
