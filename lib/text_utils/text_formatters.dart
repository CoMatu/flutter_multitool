import 'package:flutter/services.dart';

/// Форматирует текст при вводе - все слова начинаем с заглавной буквы
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final _length = newValue.text.length;
    if (_length == 1 ||
        (newValue.text.length > 1 && newValue.text[_length - 2] == ' ')) {
      //находим символ по индексу
      final oldChar = newValue.text[_length - 1];
      // капитализируем символ
      final newChar = oldChar.toUpperCase();
      // замена символа на заглавный
      final newText = replaceCharAt(newValue.text, _length - 1, newChar);

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
