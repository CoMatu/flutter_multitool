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

/// Для форматирования ввода числа (добавление пробела между разрядами), например, 1 474 745
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const separator = ' '; // Change this to '.' for other locales

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Short-circuit if the new value is empty
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Handle "deletion" of separator character
    String oldValueText = oldValue.text.replaceAll(separator, '');
    String newValueText = newValue.text.replaceAll(separator, '');

    if (oldValue.text.endsWith(separator) &&
        oldValue.text.length == newValue.text.length + 1) {
      newValueText = newValueText.substring(0, newValueText.length - 1);
    }

    // Only process if the old value and new value are different
    if (oldValueText != newValueText) {
      // Split the string into its integer and decimal parts
      List<String> parts = newValueText.split('.');

      int selectionIndex = newValue.text.length -
          newValue.selection
              .extentOffset; // + (parts.length > 1 ? parts[1].length : 0);
      final chars = parts[0].split('');

      String newString = '';
      for (int i = chars.length - 1; i >= 0; i--) {
        if ((chars.length - 1 - i) % 3 == 0 && i != chars.length - 1) {
          newString = separator + newString;
        }
        newString = chars[i] + newString;
      }

      return TextEditingValue(
        text: newString.toString() + (parts.length > 1 ? '.${parts[1]}' : ''),
        selection: TextSelection.collapsed(
          offset: newString.length -
              selectionIndex +
              (parts.length > 1 ? parts[1].length + 1 : 0),
        ),
      );
    }

    // If the new value and old value are the same, just return as-is
    return newValue;
  }
}
