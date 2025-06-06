import 'package:flutter/material.dart';

class ProfileText extends StatelessWidget {
  final String value;
  final double size;
  final bool bold;

  const ProfileText({
    super.key,
    required this.value,
    required this.size,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: size,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        color: Colors.white,
      ),
    );
  }
}
