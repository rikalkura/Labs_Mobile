import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF222222),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.greenAccent, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text('$label:',
                  style: const TextStyle(color: Colors.white70, fontSize: 18)),
            ),
            Expanded(
              child: Text(value,
                  style: const TextStyle(color: Colors.white54, fontSize: 18),
                  textAlign: TextAlign.right),
            ),
          ],
        ),
      ),
    );
  }
}
