import 'package:equatable/equatable.dart';

import '../../mainpage/models/product_model.dart';

enum ProductDetailStatus {
  initial,
  loading,
  loaded,
  saving,
  saved,
  deleting,
  deleted,
  error,
}

class ProductDetailState extends Equatable {
  final ProductDetailStatus status;
  final Product? product;
  final String errorMessage;
  final bool isEditMode; // true = edit/update, false = create

  const ProductDetailState({
    this.status = ProductDetailStatus.initial,
    this.product,
    this.errorMessage = '',
    this.isEditMode = false,
  });

  ProductDetailState copyWith({
    ProductDetailStatus? status,
    Product? product,
    String? errorMessage,
    bool? isEditMode,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      product: product ?? this.product,
      errorMessage: errorMessage ?? this.errorMessage,
      isEditMode: isEditMode ?? this.isEditMode,
    );
  }

  @override
  List<Object?> get props => [status, product, errorMessage, isEditMode];
}
