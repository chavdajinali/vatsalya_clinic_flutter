import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

showSnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ),
  );
  if (kDebugMode) {
    print("##MS- $message");
  }
}

DateTime prepareEndDate(DateTime dateTime) {
  return dateTime.copyWith(
      hour: 23, minute: 59, second: 59, millisecond: 0, microsecond: 0);
}
