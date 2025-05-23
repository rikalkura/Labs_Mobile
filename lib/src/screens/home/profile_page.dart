import 'package:flutter/material.dart';

import '../../repo/implementation/user_repository_local.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final storage =   SharedPrefsUserStorage();

  Map<String, String>? userData;

  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final data = await storage.getUser();
    setState(() {
      userData = data;
      nameController.text = data?['name'] ?? '';
      dobController.text = data?['dob'] ?? '';
      addressController.text = data?['address'] ?? '';
      emailController.text = data?['email'] ?? '';
    });
  }

  Future<void> _saveChanges() async {
    await storage.updateUser({
      'name': nameController.text.trim(),
      'dob': dobController.text.trim(),
      'address': addressController.text.trim(),
      'email': emailController.text.trim(),
    });
    setState(() {
      isEditing = false;
    });
    await _loadUser();
  }

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
            Text('Profile', style: TextStyle(fontSize: 22, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
            },
          ),
        ],
      ),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
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
                CircleAvatar(
                  radius: screenWidth < 500 ? 50 : 60,
                  backgroundColor: Colors.grey[800],
                  child: const Icon(Icons.person_outline, size: 60, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                isEditing
                    ? _buildEditableField('Full Name', nameController)
                    : _buildProfileText(nameController.text, 28, bold: true),

                const SizedBox(height: 8),
                isEditing
                    ? _buildEditableField('Email', emailController)
                    : _buildProfileText(emailController.text, 16),

                const SizedBox(height: 32),
                isEditing
                    ? _buildEditableField('Birthday', dobController)
                    : _buildProfileCard(Icons.cake, 'Birthday', dobController.text),

                isEditing
                    ? _buildEditableField('Address', addressController)
                    : _buildProfileCard(Icons.location_on, 'Location', addressController.text),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isEditing) {
                        _saveChanges();
                      } else {
                        setState(() => isEditing = true);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent[400],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      isEditing ? 'Save Changes' : 'Edit Profile',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
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
            Expanded(
              child: Text(
                '$label:',
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(color: Colors.white54, fontSize: 18),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.greenAccent),
          filled: true,
          fillColor: const Color(0xFF1E1E1E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileText(String value, double size, {bool bold = false}) {
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
