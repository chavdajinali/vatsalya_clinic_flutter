import 'package:flutter/material.dart';

class AppLabelValue extends StatelessWidget {
  final String label;
  final String value;

  const AppLabelValue({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ",
        ),
        Expanded(child: Text(value, style: const TextStyle(color: Colors.grey))),
      ],
    );
  }
}
