import 'package:flutter/material.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(
          backgroundColor: Colors.blue,
          color: Colors.white,
        ),
      ),
    ));
  }
}
