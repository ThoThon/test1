import 'package:hive/hive.dart';

part 'cart_item.g.dart';

@HiveType(typeId: 1)
class CartItem {
  @HiveField(0)
  final int productId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int price;

  @HiveField(3)
  final String cover;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.cover,
  });

  CartItem copyWith({
    int? productId,
    String? name,
    int? price,
    String? cover,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      cover: cover ?? this.cover,
    );
  }
}
