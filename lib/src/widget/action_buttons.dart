import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth < 360 ? 12.0 : 20.0;
    final buttonFontSize = screenWidth < 360 ? 12.0 : 14.0;
    final iconSize = screenWidth < 360 ? 18.0 : 22.0;

    return SizedBox(
      height: 65,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            _buildActionButton(Icons.bug_report, 'Add Spider', iconSize,
                buttonFontSize, horizontalPadding),
            const SizedBox(width: 12),
            _buildActionButton(Icons.sensors, 'Check Sensors', iconSize,
                buttonFontSize, horizontalPadding),
            const SizedBox(width: 12),
            _buildActionButton(Icons.analytics, 'Create Report', iconSize,
                buttonFontSize, horizontalPadding),
            const SizedBox(width: 12),
            _buildActionButton(Icons.cloud_download, 'Sync Data', iconSize,
                buttonFontSize, horizontalPadding),
            const SizedBox(width: 12),
            _buildActionButton(Icons.delete, 'Clear', iconSize, buttonFontSize,
                horizontalPadding),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    double iconSize,
    double fontSize,
    double paddingX,
  ) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: iconSize),
      label: Text(
        label,
        style: TextStyle(fontSize: fontSize),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: paddingX, vertical: 14),
        backgroundColor: const Color(0xFF2A2A2A),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
