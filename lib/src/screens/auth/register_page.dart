import 'package:flutter/material.dart';

import '../../repo/implementation/user_repository_local.dart';
import '../../utils/validators.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final storage = SharedPrefsUserStorage();

  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Row(
          children: const [
            Icon(Icons.bug_report, color: Colors.greenAccent, size: 28),
            SizedBox(width: 8),
            Text(
              'Spider Scanner',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF121212),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double formWidth = constraints.maxWidth > 600 ? 500 : double.infinity;
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: formWidth),
                  child: Column(
                    children: [
                      const Icon(Icons.person_add_alt_1,
                          size: 72, color: Colors.white70),
                      const SizedBox(height: 24),
                      const Text(
                        'Create Account',
                        style: TextStyle(fontSize: 28, color: Colors.white),
                      ),
                      const SizedBox(height: 32),

                      _buildTextField(
                        hint: 'Full Name',
                        icon: Icons.person_outline,
                        obscureText: false,
                        controller: nameController,
                      ),
                      const SizedBox(height: 20),

                      _buildTextField(
                        hint: 'Date of Birth (DD/MM/YYYY)',
                        icon: Icons.cake_outlined,
                        obscureText: false,
                        controller: dobController,
                      ),
                      const SizedBox(height: 20),

                      _buildTextField(
                        hint: 'Address',
                        icon: Icons.location_on_outlined,
                        obscureText: false,
                        controller: addressController,
                      ),
                      const SizedBox(height: 20),

                      _buildTextField(
                        hint: 'Email',
                        icon: Icons.email_outlined,
                        obscureText: false,
                        controller: emailController,
                      ),
                      const SizedBox(height: 20),

                      _buildTextField(
                        hint: 'Password',
                        icon: Icons.lock_outline,
                        obscureText: true,
                        controller: passwordController,
                      ),
                      const SizedBox(height: 20),

                      if (errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            errorMessage!,
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        ),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _onRegisterPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent[400],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? ",
                              style: TextStyle(color: Colors.white70)),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _onRegisterPressed() async {
    final name = nameController.text.trim();
    final dob = dobController.text.trim();
    final address = addressController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    final nameError = Validators.validateName(name);
    final emailError = Validators.validateEmail(email);
    final passwordError = Validators.validatePassword(password);

    if (nameError != null) {
      setState(() => errorMessage = nameError);
      return;
    }
    if (emailError != null) {
      setState(() => errorMessage = emailError);
      return;
    }
    if (passwordError != null) {
      setState(() => errorMessage = passwordError);
      return;
    }

    setState(() => errorMessage = null);

    // Збереження користувача
    await storage.saveUser({
      'name': name,
      'dob': dob,
      'address': address,
      'email': email,
      'password': password,
    });

    // Перевіряємо, чи ще є контекст (widget у дереві)
    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/');
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    required bool obscureText,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.white54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
