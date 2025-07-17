import 'package:flutter/material.dart';

class ReusableCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String label;

  const ReusableCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        Text(label),
        SizedBox(
          width: 16,
        )
      ],
    );
    return CheckboxListTile(
      value: value,
      onChanged: onChanged, checkboxShape: CircleBorder(),
      title: Text(label),
      // controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
