import 'package:flutter/material.dart';

// TextField Builder
Widget buildTextField(
    {required TextEditingController controller,
    required String labelText,
    required bool obscureText,
    String? Function(String?)? onValidate}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: labelText,
      filled: true,
      fillColor: Colors.grey[200],
      // Light grey for text field
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    ),
    validator: onValidate,
    obscureText: obscureText,
  );
}