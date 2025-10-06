import 'package:equatable/equatable.dart';

import '../../product_list_page/models/product_model.dart';

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
  final bool showDeleteDialog;

  const ProductDetailState({
    this.status = ProductDetailStatus.initial,
    this.product,
    this.errorMessage = '',
    this.isEditMode = false,
    this.showDeleteDialog = false,
  });

  ProductDetailState copyWith({
    ProductDetailStatus? status,
    Product? product,
    String? errorMessage,
    bool? isEditMode,
    bool? showDeleteDialog,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      product: product ?? this.product,
      errorMessage: errorMessage ?? this.errorMessage,
      isEditMode: isEditMode ?? this.isEditMode,
      showDeleteDialog: showDeleteDialog ?? this.showDeleteDialog,
    );
  }

  @override
  List<Object?> get props => [
        status,
        product,
        errorMessage,
        isEditMode,
        showDeleteDialog,
      ];
}
