import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Icon(Icons.lock_outline, size: 72, color: Colors.white70),
        SizedBox(height: 24),
        Text(
          'Welcome Back',
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.w400, color: Colors.white),
        ),
      ],
    );
  }
}
