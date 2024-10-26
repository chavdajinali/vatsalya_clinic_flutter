import 'package:flutter/material.dart';

class CustomPicker extends StatelessWidget {
  final List<String> items; // List of items to display
  final String title; // Title for the picker
  final ValueChanged<String> onSelected; // Callback for when an item is selected

  const CustomPicker({super.key,
    required this.items,
    required this.onSelected,
    this.title = 'Select an Option',
  });

  // Show the picker as a modal bottom sheet
  static void show({
    required BuildContext context,
    required List<String> items,
    required ValueChanged<String> onSelected,
    String title = 'Select an Option',
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CustomPicker(
          items: items,
          onSelected: onSelected,
          title: title,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(),
        ListView.builder(
          shrinkWrap: true, // Ensure the list fits within the modal height
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(items[index]),
              onTap: () {
                onSelected(items[index]); // Pass the selected value to the callback
                Navigator.pop(context); // Close the modal
              },
            );
          },
        ),
      ],
    );
  }
}
