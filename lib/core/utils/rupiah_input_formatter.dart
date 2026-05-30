import 'package:flutter/services.dart';
import 'currency_formatter.dart';

/// Memformat input angka dengan pemisah ribuan Indonesia (titik).
class RupiahInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(text: '');
    }

    final number = double.parse(digits);
    final formatted = CurrencyFormatter.formatNumber(number);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
