import 'package:flutter/material.dart';

class InputFieldLabel extends StatelessWidget {
  const InputFieldLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF121212),
      ),
    );
  }
}
