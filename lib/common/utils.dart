import 'dart:convert';

final defaultDelay = Duration(milliseconds: 700);

String getTimestamp() {
  final now = DateTime.now();
  return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}.${now.millisecond.toString().padLeft(3, '0')}";
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
