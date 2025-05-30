import 'package:flutter/material.dart';
import 'package:untitled/src/screens/auth/login_page.dart';
import 'package:untitled/src/screens/auth/register_page.dart';
import 'package:untitled/src/screens/home/home_page.dart';
import 'package:untitled/src/screens/home/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spider Scanner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
