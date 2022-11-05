/// Возвращает склонение слова в зависимости от количества
String getNoun(int howMany, String one, String two, String five) {
  var n = howMany % 100;
  if (n >= 5 && n <= 20) {
    return five;
  }
  n = howMany % 10;
  if (n == 1) {
    return one;
  }
  if (n >= 2 && n <= 4) {
    return two;
  }
  return five;
}

/// Парсит строку и проверяет наличие ссылки. если ссылка не найдена,
/// возвращает пустую строку.
String parseLink(String text) {
  var link = '';
  // --- парсим строку и проверяем наличие ссылки --- //

  try {
    final exp = RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');

    final matches = exp.allMatches(text);

    link = text.substring(matches.first.start, matches.first.end);
  } finally {
    // ignore: control_flow_in_finally
    return link;
  }
}
