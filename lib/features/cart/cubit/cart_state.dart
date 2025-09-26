import 'package:equatable/equatable.dart';

import '../models/cart_item.dart';

class CartState extends Equatable {
  final List<CartItem> cartItems;
  final int totalItems;
  final int totalPrice;

  const CartState({
    this.cartItems = const [],
    this.totalItems = 0,
    this.totalPrice = 0,
  });

  CartState copyWith({
    List<CartItem>? cartItems,
    int? totalItems,
    int? totalPrice,
  }) {
    return CartState(
      cartItems: cartItems ?? this.cartItems,
      totalItems: totalItems ?? this.totalItems,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  @override
  List<Object> get props => [cartItems, totalItems, totalPrice];
}
