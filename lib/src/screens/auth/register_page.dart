import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/src/repo/implementation/user_repository_local.dart';

import 'cubit/register_cubit.dart';
import 'design_reg/register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(storage: SharedPrefsUserStorage()),
      child: const Scaffold(
        backgroundColor: Color(0xFF121212),
        appBar: _RegisterAppBar(),
        body: RegisterForm(),
      ),
    );
  }
}

class _RegisterAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _RegisterAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      automaticallyImplyLeading: false,
      title: Row(
        children: const [
          Icon(Icons.bug_report, color: Colors.greenAccent, size: 28),
          SizedBox(width: 8),
          Text('Spider Scanner',
              style: TextStyle(fontSize: 22, color: Colors.white)),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
