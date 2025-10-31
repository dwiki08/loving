import 'dart:convert';

import 'package:intl/intl.dart';

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

String formatDuration(Duration duration) {
  return duration.toString().split('.').first.padLeft(8, "0");
}

int safeParseInt(dynamic value) {
  if (value == null) {
    return -1;
  }
  if (value is int) {
    return value;
  }
  if (value is double) {
    return value.toInt();
  }
  if (value is String) {
    double? doubleValue = double.tryParse(value);
    if (doubleValue != null) {
      return doubleValue.toInt();
    }
    return int.tryParse(value) ?? -1;
  }
  return -1;
}
