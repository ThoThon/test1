import 'package:hive_flutter/hive_flutter.dart';

import '../../features/cart/models/cart_item.dart';
import '../../features/login/models/login_info.dart';
import '../../features/login/models/login_storage.dart';

class HiveStorage {
  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(LoginInfoAdapter());
    Hive.registerAdapter(CartItemAdapter());

    await Hive.openBox<LoginInfo>(LoginStorage.boxName);
    await Hive.openBox<CartItem>('cartBox');
  }
}
