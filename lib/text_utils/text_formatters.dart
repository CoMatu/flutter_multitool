import 'package:flutter/services.dart';
import 'dart:math' as math;

/// Форматирует текст при вводе - все слова начинаем с заглавной буквы
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final length = newValue.text.length;
    if (length == 1 ||
        (newValue.text.length > 1 && newValue.text[length - 2] == ' ')) {
      //находим символ по индексу
      final oldChar = newValue.text[length - 1];
      // капитализируем символ
      final newChar = oldChar.toUpperCase();
      // замена символа на заглавный
      final newText = replaceCharAt(newValue.text, length - 1, newChar);

      return TextEditingValue(
        text: newText,
        selection: newValue.selection,
      );
    } else {
      return TextEditingValue(
        text: newValue.text,
        selection: newValue.selection,
      );
    }
  }

  String replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) +
        newChar +
        oldString.substring(index + 1);
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange});

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    String value = newValue.text;

    if (value.contains(".") &&
        value.substring(value.indexOf(".") + 1).length > decimalRange) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value == ".") {
      truncated = "0.";

      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(truncated.length, truncated.length + 1),
        extentOffset: math.min(truncated.length, truncated.length + 1),
      );
    }

    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}
