import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'features/home/ui/home_screen.dart';
import 'features/login/ui/login_screen.dart';
import 'repositories/auth_repository.dart';
import 'services/local/hive_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveStorage.init();

  final bool hasLogin = AuthRepository.isLoggedIn;

  runApp(MyApp(hasLogin: hasLogin));
}

class MyApp extends StatelessWidget {
  final bool hasLogin;
  const MyApp({super.key, required this.hasLogin});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Bloc App',
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoSansTextTheme(),
      ),
      home: hasLogin ? const HomeScreen() : const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
