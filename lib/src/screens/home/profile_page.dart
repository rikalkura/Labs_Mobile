import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/src/repo/implementation/user_repository_local.dart';
import 'package:untitled/src/screens/home/views/profile_view.dart';

import 'cubit/profile_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProfileCubit(storage: SharedPrefsUserStorage())..loadUser(),
      child: const ProfileView(),
    );
  }
}
