import 'package:flutter/material.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Icon(Icons.person_add_alt_1, size: 72, color: Colors.white70),
        SizedBox(height: 24),
        Text('Create Account',
            style: TextStyle(fontSize: 28, color: Colors.white)),
      ],
    );
  }
}
