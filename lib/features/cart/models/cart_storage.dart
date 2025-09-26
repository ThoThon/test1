import 'package:hive/hive.dart';

import 'cart_item.dart';

class CartStorage {
  static const String boxName = 'cartBox';
  static Box<CartItem> get _box => Hive.box<CartItem>(boxName);

  // Thêm sản phẩm
  static Future<void> addToCart(CartItem item) async {
    final key = 'product/${item.productId}';
    await _box.put(key, item);
  }

  // Lấy tất cả sản phẩm
  static List<CartItem> getCartItems() {
    return _box.values.toList();
  }

  // Xóa sản phẩm theo ID
  static Future<void> removeFromCart(int productId) async {
    final key = 'product/$productId';
    await _box.delete(key);
  }

  // Xóa hết
  static Future<void> clearCart() async {
    await _box.clear();
  }

  // Đếm số lượng
  static int get itemCount => _box.length;

  // Tính tổng tiền
  static int get totalPrice {
    return _box.values.fold(0, (total, item) => total + item.price);
  }

  // Kiểm tra sản phẩm có trong giỏ hàng không
  static bool isInCart(int productId) {
    final key = 'product/$productId';
    return _box.containsKey(key);
  }

  // Lấy sản phẩm theo ID
  static CartItem? getCartItem(int productId) {
    final key = 'product/$productId';
    return _box.get(key);
  }
}
