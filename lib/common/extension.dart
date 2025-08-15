import 'package:xml/xml.dart';
import 'dart:convert';

extension XmlValidation on String {
  bool get isValidXml {
    try {
      XmlDocument.parse(this);
      return true;
    } catch (_) {
      return false;
    }
  }
}

extension JsonValidation on String {
  bool get isValidJson {
    try {
      json.decode(this);
      return true;
    } catch (_) {
      return false;
    }
  }
}