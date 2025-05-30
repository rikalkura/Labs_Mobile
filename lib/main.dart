import 'package:flutter/material.dart';
import 'package:untitled/src/screens/auth/login_page.dart';
import 'package:untitled/src/screens/auth/register_page.dart';
import 'package:untitled/src/screens/home/home_page.dart';
import 'package:untitled/src/screens/home/profile_page.dart';
import 'package:untitled/src/repo/implementation/user_repository_local.dart';
import 'package:untitled/src/services/connectivity_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<(bool isLoggedIn, bool isOnline)> _checkAuthAndInternet() async {
    final storage = SharedPrefsUserStorage();
    final connectivity = ConnectivityService();

    final user = await storage.getUser();
    final isOnline = await connectivity.isConnected();

    return (user != null, isOnline);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spider Scanner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: FutureBuilder<(bool, bool)>(
        future: _checkAuthAndInternet(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          final (isLoggedIn, isOnline) = snapshot.data!;

          // Якщо залогінено, але немає Інтернету — покажемо попередження
          if (isLoggedIn && !isOnline) {
            // використаємо post frame callback щоб не зламати build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Offline mode: limited functionality"),
                  backgroundColor: Colors.orangeAccent,
                ),
              );
            });
          }

          return isLoggedIn ? const HomePage() : const LoginPage();
        },
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
