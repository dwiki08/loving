import 'dart:convert';

final defaultDelay = Duration(milliseconds: 700);

String getTimestamp() {
  return DateTime.now().toIso8601String().substring(11, 23);
}

String normalize(String text) {
  return text
      .toLowerCase()
      .trim()
      .replaceAll('`', "'")
      .replaceAll('\u2019', "'");
}

String prettyJson(Object? json) {
  return JsonEncoder.withIndent('  ').convert(json);
}
