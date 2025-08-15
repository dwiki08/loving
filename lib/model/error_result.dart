import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

@immutable
class ErrorResult {
  final String message;
  final int? code;
  final Object? error;

  const ErrorResult({required this.message, this.code, this.error});

  static ErrorResult createResult(Object error) {
    String errorMsg = 'Error';
    int? code;
    try {
      if (error is DioException) {
        log('dioException: [${error.response?.realUri}] - $error');
        code = error.response?.statusCode;
        errorMsg = error.response?.statusMessage ?? "Network Error";
      } else if (error is Error) {
        log('error: ${error.toString()}');
        errorMsg = error.toString();
      } else if (error is Exception) {
        log('exception: ${error.toString()}');
        errorMsg = error.toString();
      } else {
        errorMsg = "Unknown Error";
      }
      return ErrorResult(message: errorMsg, error: error, code: code);
    } on Exception catch (e) {
      return ErrorResult(message: errorMsg, error: e, code: code);
    }
  }
}
