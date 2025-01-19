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
