import 'package:flutter_bloc/flutter_bloc.dart';

import '../../product_list_page/models/product_model.dart';
import '../models/cart_item.dart';
import '../models/cart_storage.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState()) {
    loadCartItems();
  }

  void loadCartItems() {
    final items = CartStorage.getCartItems();
    final totalItems = CartStorage.itemCount;
    final totalPrice = CartStorage.totalPrice;

    emit(state.copyWith(
      cartItems: items,
      totalItems: totalItems,
      totalPrice: totalPrice,
    ));
  }

  Future<void> addToCart(Product product) async {
    final cartItem = CartItem(
      productId: product.id,
      name: product.name,
      price: product.price,
      cover: product.cover,
    );
    await CartStorage.addToCart(cartItem);
    loadCartItems();
  }

  Future<void> removeFromCart(int productId) async {
    await CartStorage.removeFromCart(productId);
    loadCartItems();
  }

  Future<void> clearCart() async {
    await CartStorage.clearCart();
    loadCartItems();
  }

  bool isInCart(int productId) {
    return CartStorage.isInCart(productId);
  }

  CartItem? getCartItem(int productId) {
    return CartStorage.getCartItem(productId);
  }
}
