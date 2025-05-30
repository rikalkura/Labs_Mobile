import 'package:flutter/material.dart';
import '../../repo/implementation/user_repository_local.dart';
import '../../services/connectivity_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final storage = SharedPrefsUserStorage();
  final connectivity = ConnectivityService();

  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF121212),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double horizontalPadding = screenWidth < 600 ? screenWidth * 0.06 : screenWidth * 0.2;
          double maxFormWidth = 500;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxFormWidth),
                  child: Column(
                    children: [
                      const Icon(Icons.lock_outline, size: 72, color: Colors.white70),
                      const SizedBox(height: 24),
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 32),

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
                      const SizedBox(height: 12),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(color: Colors.white60),
                          ),
                        ),
                      ),

                      if (errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            errorMessage!,
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        ),

                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final isOnline = await connectivity.isConnected();
                            if (!isOnline) {
                              if (context.mounted){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("No internet connection"),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                              }
                              return;
                            }

                            final enteredEmail = emailController.text.trim();
                            final enteredPassword = passwordController.text;
                            final savedUser = await storage.getUser();

                            if (savedUser == null) {
                              setState(() => errorMessage = 'User not found. Please register.');
                              return;
                            }

                            if (savedUser['email'] != enteredEmail ||
                                savedUser['password'] != enteredPassword) {
                              setState(() => errorMessage = 'Incorrect email or password');
                              return;
                            }
                            if (context.mounted) {
                              setState(() => errorMessage = null);
                              Navigator.pushReplacementNamed(context, '/home');
                            }
                            },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent[400],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(color: Colors.white70),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: const Text(
                              'Register',
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
