import 'package:equatable/equatable.dart';

import '../../product_list_page/models/product_model.dart';

enum LoadingStatus {
  initial,
  loading,
  loaded,
  error,
}

class ProductDetailState extends Equatable {
  final LoadingStatus getProductDetailStatus;
  final LoadingStatus saveProductStatus;
  final LoadingStatus deleteProductStatus;

  final Product? product;
  final String errorMessage;
  final bool isEditMode; // true = edit/update, false = create

  const ProductDetailState({
    this.getProductDetailStatus = LoadingStatus.initial,
    this.saveProductStatus = LoadingStatus.initial,
    this.deleteProductStatus = LoadingStatus.initial,
    this.product,
    this.errorMessage = '',
    this.isEditMode = false,
  });

  ProductDetailState copyWith({
    LoadingStatus? getProductDetailStatus,
    LoadingStatus? saveProductStatus,
    LoadingStatus? deleteProductStatus,
    Product? product,
    String? errorMessage,
    bool? isEditMode,
  }) {
    return ProductDetailState(
      getProductDetailStatus:
          getProductDetailStatus ?? this.getProductDetailStatus,
      saveProductStatus: saveProductStatus ?? this.saveProductStatus,
      deleteProductStatus: deleteProductStatus ?? this.deleteProductStatus,
      product: product ?? this.product,
      errorMessage: errorMessage ?? this.errorMessage,
      isEditMode: isEditMode ?? this.isEditMode,
    );
  }

  @override
  List<Object?> get props => [
        getProductDetailStatus,
        saveProductStatus,
        deleteProductStatus,
        product,
        errorMessage,
        isEditMode,
      ];
}
