import 'package:flutter/material.dart';

import 'repositories/auth_repository.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'services/local/hive_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveStorage.init();

  final bool hasLogin = AuthRepository.isLoggedIn;

  runApp(MyApp(initialRoute: hasLogin ? Routes.home : Routes.login));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      onGenerateRoute: AppPages.generateRoute,
    );
  }
}
