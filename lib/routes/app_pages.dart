import 'package:flutter/material.dart';

import '../features/cart/ui/cart_screen.dart';
import '../features/home/ui/home_screen.dart';
import '../features/login/ui/login_screen.dart';
import '../features/product_detail/ui/product_detail_screen.dart';
import 'app_routes.dart';

class AppPages {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case Routes.cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());

      case Routes.productDetail:
        final int? productId = settings.arguments as int?;
        return MaterialPageRoute(
          builder: (_) => const ProductDetailScreen(),
          settings: RouteSettings(arguments: productId),
        );

      case Routes.productCreate:
        return MaterialPageRoute(
          builder: (_) => const ProductDetailScreen(),
          settings: const RouteSettings(arguments: null),
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
