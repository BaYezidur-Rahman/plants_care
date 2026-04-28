import 'package:intl/intl.dart';
import 'bangla_numbers.dart';

class DateHelpers {
  static String calculateAge(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    final days = difference.inDays;
    if (days < 30) {
      return '$days days';
    } else if (days < 365) {
      final months = (days / 30).floor();
      return '$months months';
    } else {
      final years = (days / 365).floor();
      return '$years years';
    }
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String banglaDate(DateTime date) {
    final day = BanglaNumbers.toBangla(date.day.toString());
    final year = BanglaNumbers.toBangla(date.year.toString());
    final monthsBn = [
      'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
      'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'
    ];
    final month = monthsBn[date.month - 1];
    return '$day $month $year';
  }

  static String getBanglaDay(DateTime date) {
    final daysBn = ['সোম', 'মঙ্গল', 'বুধ', 'বৃহঃ', 'শুক্র', 'শনি', 'রবি'];
    return daysBn[date.weekday - 1];
  }
}
