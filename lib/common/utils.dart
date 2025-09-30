import 'dart:convert';

import 'package:intl/intl.dart';

final defaultDelay = Duration(milliseconds: 700);

String getTimestamp({DateTime? dateTime, String? format = 'HH:mm:ss.SSS'}) {
  return DateFormat(format).format(dateTime ?? DateTime.now());
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
