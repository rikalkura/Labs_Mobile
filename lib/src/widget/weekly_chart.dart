import 'package:flutter/material.dart';

class WeeklyChart extends StatelessWidget {
  final List<int> values;
  const WeeklyChart({super.key, required this.values});

  @override
  Widget build(BuildContext context) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final max = values.reduce((a, b) => a > b ? a : b);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final columnWidth = screenWidth / (days.length * 2);
    final maxBarHeight = screenHeight * 0.2;
    final fontSize = screenWidth < 360 ? 10.0 : 12.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(days.length, (index) {
          final heightFactor = max == 0 ? 0.0 : values[index] / max;

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: columnWidth,
                height: maxBarHeight * heightFactor,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                days[index],
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: fontSize,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
