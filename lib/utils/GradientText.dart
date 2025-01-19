import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const GradientText(
      this.text, {
        Key? key,
        this.style = const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [Colors.blue, Colors.green],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        text,
        style: style.copyWith(color: Colors.blue), // Use transparent color to show gradient
      ),
    );
  }
}
