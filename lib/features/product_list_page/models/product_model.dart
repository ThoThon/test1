class Product {
  final int id;
  final String name;
  final int price;
  final int quantity;
  final String cover;
  final bool isInCart;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.cover,
    this.isInCart = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'],
      cover: json['cover'],
      isInCart: false,
    );
  }

  Product copyWith({
    int? id,
    String? name,
    int? price,
    int? quantity,
    String? cover,
    bool? isInCart,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      cover: cover ?? this.cover,
      isInCart: isInCart ?? this.isInCart,
    );
  }
}
