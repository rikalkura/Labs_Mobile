import 'package:flutter/material.dart';

import '../../widget/action_buttons.dart';
import '../../widget/weekly_chart.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false, // Прибрати стрілку "назад"
        centerTitle: false,
        title: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/profile');
          },
          child: Row(
            children: const [
              Icon(Icons.person, color: Colors.greenAccent, size: 32),
              SizedBox(width: 8),
              Text(
                'Profile',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        // Видалив actions з кнопкою Logout
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Spider Scan Status',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w300,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(28),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(Icons.query_stats, color: Colors.white54, size: 26),
                      Row(
                        children: [
                          Icon(Icons.notifications_none, color: Colors.white54, size: 26),
                          SizedBox(width: 16),
                          Icon(Icons.tune, color: Colors.white54, size: 26),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text('Total Scans',
                      style: TextStyle(fontSize: 18, color: Colors.white54)),
                  const SizedBox(height: 16),
                  const Text(
                    '174',
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  WeeklyChart(values: [20, 45, 30, 60, 25, 40, 35]),
                  const SizedBox(height: 12),
                  const Text(
                    'Last updated: 2 mins ago',
                    style: TextStyle(color: Colors.white38, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Actions',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 12),

            const ActionButtons(),
          ],
        ),
      ),
    );
  }
}
