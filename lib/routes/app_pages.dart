import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/cart/cubit/cart_cubit.dart';
import '../features/cart/ui/cart_screen.dart';
import '../features/home/ui/home_screen.dart';
import '../features/login/ui/login_screen.dart';
import 'app_routes.dart';

class AppPages {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.cart:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => CartCubit(),
            child: const CartScreen(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
