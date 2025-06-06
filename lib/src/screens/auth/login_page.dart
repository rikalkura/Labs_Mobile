import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/src/repo/implementation/user_repository_local.dart';
import 'package:untitled/src/services/connectivity_service.dart';

import 'cubit/login_cubit.dart';
import 'design_login/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(
        storage: SharedPrefsUserStorage(),
        connectivity: ConnectivityService(),
      ),
      child: const Scaffold(
        backgroundColor: Color(0xFF121212),
        appBar: _LoginAppBar(),
        body: LoginForm(),
      ),
    );
  }
}

class _LoginAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _LoginAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
                letterSpacing: 1.1),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
