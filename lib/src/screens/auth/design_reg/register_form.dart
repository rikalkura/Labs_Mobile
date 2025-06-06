import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/src/screens/auth/cubit/register_cubit.dart';
import 'package:untitled/src/screens/auth/cubit/register_state.dart';

import 'register_header.dart';
import 'register_text_field.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final formWidth = screenWidth > 600 ? 500.0 : double.infinity;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: formWidth),
            child: BlocConsumer<RegisterCubit, RegisterState>(
              listener: (context, state) {
                if (state is RegisterFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red),
                  );
                } else if (state is RegisterSuccess) {
                  Navigator.pushReplacementNamed(context, '/');
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    const RegisterHeader(),
                    const SizedBox(height: 32),
                    RegisterTextField(
                        hint: 'Full Name',
                        icon: Icons.person_outline,
                        controller: nameController),
                    const SizedBox(height: 20),
                    RegisterTextField(
                        hint: 'Date of Birth (DD/MM/YYYY)',
                        icon: Icons.cake_outlined,
                        controller: dobController),
                    const SizedBox(height: 20),
                    RegisterTextField(
                        hint: 'Address',
                        icon: Icons.location_on_outlined,
                        controller: addressController),
                    const SizedBox(height: 20),
                    RegisterTextField(
                        hint: 'Email',
                        icon: Icons.email_outlined,
                        controller: emailController),
                    const SizedBox(height: 20),
                    RegisterTextField(
                        hint: 'Password',
                        icon: Icons.lock_outline,
                        controller: passwordController,
                        obscureText: true),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is RegisterLoading
                            ? null
                            : () {
                                context.read<RegisterCubit>().register(
                                      name: nameController.text.trim(),
                                      dob: dobController.text.trim(),
                                      address: addressController.text.trim(),
                                      email: emailController.text.trim(),
                                      password: passwordController.text,
                                    );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent[400],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: state is RegisterLoading
                            ? const CircularProgressIndicator(
                                color: Colors.black)
                            : const Text('Register',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black)),
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
                          child: const Text('Login',
                              style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
