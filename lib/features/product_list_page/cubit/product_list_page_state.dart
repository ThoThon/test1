import 'package:equatable/equatable.dart';

import '../models/product_model.dart';

class ProductListPageState extends Equatable {
  final List<Product> products;
  final bool isLoading;
  final String errorMessage;
  final int totalCartItems;

  const ProductListPageState({
    this.products = const [],
    this.isLoading = false,
    this.errorMessage = '',
    this.totalCartItems = 0,
  });

  ProductListPageState copyWith({
    List<Product>? products,
    bool? isLoading,
    String? errorMessage,
    int? totalCartItems,
  }) {
    return ProductListPageState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      totalCartItems: totalCartItems ?? this.totalCartItems,
    );
  }

  @override
  List<Object> get props => [
        products,
        isLoading,
        errorMessage,
        totalCartItems,
      ];
}
