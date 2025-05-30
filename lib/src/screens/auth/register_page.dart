import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
                      ),
                      const SizedBox(height: 20),

                      _buildTextField(
                        hint: 'Date of Birth (DD/MM/YYYY)',
                        icon: Icons.cake_outlined,
                        obscureText: false,
                      ),
                      const SizedBox(height: 20),

                      _buildTextField(
                        hint: 'Address',
                        icon: Icons.location_on_outlined,
                        obscureText: false,
                      ),
                      const SizedBox(height: 20),

                      _buildTextField(
                        hint: 'Email',
                        icon: Icons.email_outlined,
                        obscureText: false,
                      ),
                      const SizedBox(height: 20),

                      _buildTextField(
                        hint: 'Password',
                        icon: Icons.lock_outline,
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/');
                          },
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

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    required bool obscureText,
  }) {
    return TextField(
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
