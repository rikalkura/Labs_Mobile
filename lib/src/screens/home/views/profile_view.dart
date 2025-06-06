import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/src/screens/home/cubit/profile_cubit.dart';
import 'package:untitled/src/screens/home/cubit/profile_state.dart';
import 'package:untitled/src/screens/home/design_profile/editable_field.dart';
import 'package:untitled/src/screens/home/design_profile/profile_card.dart';
import 'package:untitled/src/screens/home/design_profile/profile_text.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoggedOut) {
          Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is ProfileLoaded) {
          nameController.text = state.userData['name'] ?? '';
          dobController.text = state.userData['dob'] ?? '';
          addressController.text = state.userData['address'] ?? '';
          emailController.text = state.userData['email'] ?? '';
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final isEditing = (state is ProfileLoaded) ? state.isEditing : false;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Row(
              children: [
                Icon(Icons.person, color: Colors.greenAccent, size: 28),
                SizedBox(width: 8),
                Text('Profile',
                    style: TextStyle(fontSize: 22, color: Colors.white)),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: Colors.white),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Log out'),
                      content: const Text('Are you sure you want to log out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Log out'),
                        ),
                      ],
                    ),
                  );
                  if (!context.mounted) return;
                  if (confirm == true) {
                    context.read<ProfileCubit>().logout();
                  }
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
                    CircleAvatar(
                      radius: screenWidth < 500 ? 50 : 60,
                      backgroundColor: Colors.grey[800],
                      child: const Icon(Icons.person_outline,
                          size: 60, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    isEditing
                        ? EditableField(
                            label: 'Full Name', controller: nameController)
                        : ProfileText(
                            value: nameController.text, size: 28, bold: true),
                    const SizedBox(height: 8),
                    isEditing
                        ? EditableField(
                            label: 'Email', controller: emailController)
                        : ProfileText(value: emailController.text, size: 16),
                    const SizedBox(height: 32),
                    isEditing
                        ? EditableField(
                            label: 'Birthday', controller: dobController)
                        : ProfileCard(
                            icon: Icons.cake,
                            label: 'Birthday',
                            value: dobController.text),
                    isEditing
                        ? EditableField(
                            label: 'Address', controller: addressController)
                        : ProfileCard(
                            icon: Icons.location_on,
                            label: 'Address',
                            value: addressController.text),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (isEditing) {
                            context.read<ProfileCubit>().saveChanges({
                              'name': nameController.text.trim(),
                              'dob': dobController.text.trim(),
                              'address': addressController.text.trim(),
                              'email': emailController.text.trim(),
                            });
                          } else {
                            context.read<ProfileCubit>().toggleEditMode();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent[400],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(
                          isEditing ? 'Save Changes' : 'Edit Profile',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
