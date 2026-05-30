import 'package:intl/intl.dart';

/// Format nominal Rupiah dengan pemisah ribuan (contoh: Rp 1.500.000).
abstract final class CurrencyFormatter {
  static final NumberFormat _rupiah = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static final NumberFormat _number = NumberFormat.decimalPattern('id_ID');

  static String format(double amount) => _rupiah.format(amount);

  static String formatNumber(double amount) => _number.format(amount);

  static double? parse(String text) {
    final digits = text.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) return null;
    return double.tryParse(digits);
  }
}
