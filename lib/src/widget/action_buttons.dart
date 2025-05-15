import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildActionButton(Icons.bug_report, 'Add Spider'),
            const SizedBox(width: 12),
            _buildActionButton(Icons.sensors, 'Check Sensors'),
            const SizedBox(width: 12),
            _buildActionButton(Icons.analytics, 'Create Report'),
            const SizedBox(width: 12),
            _buildActionButton(Icons.cloud_download, 'Sync Data'),
            const SizedBox(width: 12),
            _buildActionButton(Icons.delete, 'Clear'),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 22),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        backgroundColor: const Color(0xFF2A2A2A),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
