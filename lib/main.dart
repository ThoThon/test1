import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'features/cart/ui/cart_screen.dart';
import 'features/home/ui/home_screen.dart';
import 'features/login/ui/login_screen.dart';
import 'repositories/auth_repository.dart';
import 'services/local/hive_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveStorage.init();

  final bool hasLogin = AuthRepository.isLoggedIn;

  runApp(MyApp(initialRoute: hasLogin ? '/home' : '/login'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoSansTextTheme(),
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/cart': (context) => const CartScreen(),
      },
    );
  }
}
