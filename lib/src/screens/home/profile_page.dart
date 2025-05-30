import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: const [
            Icon(Icons.person, color: Colors.greenAccent, size: 28),
            SizedBox(width: 8),
            Text(
              'Profile',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF121212), Color(0xFF1E1E1E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth < 500 ? 16 : 40,
              vertical: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.greenAccent, width: 3),
                  ),
                  child: CircleAvatar(
                    radius: screenWidth < 500 ? 50 : 60,
                    backgroundColor: Colors.grey[800],
                    child: const Icon(Icons.person_outline, size: 60, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Andrii Morozov',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'andrii.morozov.ir.2022@lpnu.ua',
                  style: TextStyle(fontSize: 16, color: Colors.white54),
                ),
                const SizedBox(height: 32),
                _buildProfileCard(Icons.phone, 'Phone', '+380 96 844 23 14'),
                _buildProfileCard(Icons.location_on, 'Location', 'Lviv, Ukraine'),
                _buildProfileCard(Icons.cake, 'Birthday', '06 June 2005'),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent[400],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6,
                      shadowColor: Colors.greenAccent.withAlpha((0.6 * 255).round()),
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(IconData icon, String label, String value) {
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
            Flexible(
              flex: 1,
              child: Text(
                '$label:',
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              flex: 2,
              child: Text(
                value,
                style: const TextStyle(color: Colors.white54, fontSize: 18),
                overflow: TextOverflow.visible,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
