import 'package:flutter/material.dart';
import 'api_exceptions.dart';
import 'failures.dart';

class ErrorHandler {
  static Failure handle(Object error) {
    if (error is NetworkException) {
      return NetworkFailure(
        'Please check your internet connection and try again.',
      );
    } else if (error is ServerException) {
      return ServerFailure(error.message);
    } else if (error is ApiException) {
      return UnknownFailure(error.message);
    } else {
      return UnknownFailure(error.toString().replaceAll('Exception: ', ''));
    }
  }

  static IconData getIcon(Failure failure) {
    if (failure is NetworkFailure) return Icons.wifi_off_rounded;
    if (failure is ServerFailure) return Icons.dns_rounded;
    return Icons.error_outline_rounded;
  }
}
