import 'package:equatable/equatable.dart';

import '../models/product_model.dart';

class MainpageState extends Equatable {
  final List<Product> products;
  final bool isLoading;
  final String errorMessage;

  const MainpageState({
    this.products = const [],
    this.isLoading = false,
    this.errorMessage = '',
  });

  MainpageState copyWith({
    List<Product>? products,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MainpageState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [products, isLoading, errorMessage];
}
