import 'package:flutter/material.dart';

import '../main.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final double? fontsize;
  final VoidCallback onPressed;
  final EdgeInsets? padding;
  final bool isLoading;

  const GradientButton({
    super.key,
    required this.text,
    this.fontsize,
    required this.onPressed,
    this.padding,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.green], // Apply gradient colors here
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: isLoading
            ? CircularProgressIndicator()
            : Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize ?? 14,
                ),
              ),
      ),
    );
  }
}
