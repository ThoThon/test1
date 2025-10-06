import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/product_repository.dart';
import 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final int? productId;

  ProductDetailCubit({this.productId}) : super(const ProductDetailState()) {
    if (productId != null) {
      // Edit mode - fetch product detail
      fetchProductDetail();
    } else {
      // Create mode
      emit(state.copyWith(
        status: ProductDetailStatus.loaded,
        isEditMode: false,
      ));
    }
  }

  Future<void> fetchProductDetail() async {
    emit(state.copyWith(
      status: ProductDetailStatus.loading,
      isEditMode: true,
    ));

    try {
      final product = await ProductRepository.getProductDetail(
        productId: productId!,
      );

      if (product != null) {
        emit(state.copyWith(
          status: ProductDetailStatus.loaded,
          product: product,
        ));
      } else {
        emit(state.copyWith(
          status: ProductDetailStatus.error,
          errorMessage: "Không tìm thấy thông tin sản phẩm",
        ));
      }
    } catch (e) {
      print('Lỗi fetchProductDetail: $e');
      emit(state.copyWith(
        status: ProductDetailStatus.error,
        errorMessage: "Có lỗi xảy ra khi tải dữ liệu",
      ));
    }
  }

  Future<void> saveProduct({
    required String name,
    required int price,
    required int quantity,
    required String cover,
  }) async {
    emit(state.copyWith(status: ProductDetailStatus.saving));

    try {
      if (state.isEditMode && productId != null) {
        // Update existing product
        final updatedProduct = await ProductRepository.updateProduct(
          productId: productId!,
          name: name,
          price: price,
          quantity: quantity,
          cover: cover,
        );

        if (updatedProduct != null) {
          emit(state.copyWith(
            status: ProductDetailStatus.saved,
            product: updatedProduct,
          ));
        } else {
          emit(state.copyWith(
            status: ProductDetailStatus.error,
            errorMessage: "Cập nhật sản phẩm thất bại",
          ));
        }
      } else {
        // Create new product
        final newProduct = await ProductRepository.createProduct(
          name: name,
          price: price,
          quantity: quantity,
          cover: cover,
        );

        if (newProduct != null) {
          emit(state.copyWith(
            status: ProductDetailStatus.saved,
            product: newProduct,
          ));
        } else {
          emit(state.copyWith(
            status: ProductDetailStatus.error,
            errorMessage: "Tạo sản phẩm thất bại",
          ));
        }
      }
    } catch (e) {
      print('Lỗi saveProduct: $e');
      emit(state.copyWith(
        status: ProductDetailStatus.error,
        errorMessage: state.isEditMode
            ? "Có lỗi xảy ra khi cập nhật sản phẩm"
            : "Có lỗi xảy ra khi tạo sản phẩm",
      ));
    }
  }

  void requestDelete() {
    emit(state.copyWith(showDeleteDialog: true));
  }

  void deleteDialogShown() {
    emit(state.copyWith(showDeleteDialog: false));
  }

  Future<void> confirmDelete() async {
    if (productId == null) return;

    emit(state.copyWith(status: ProductDetailStatus.deleting));

    try {
      final success = await ProductRepository.deleteProduct(
        productId: productId!,
      );

      if (success) {
        emit(state.copyWith(status: ProductDetailStatus.deleted));
      } else {
        emit(state.copyWith(
          status: ProductDetailStatus.error,
          errorMessage: "Xóa sản phẩm thất bại",
        ));
      }
    } catch (e) {
      print('Lỗi deleteProduct: $e');
      emit(state.copyWith(
        status: ProductDetailStatus.error,
        errorMessage: "Có lỗi xảy ra khi xóa sản phẩm",
      ));
    }
  }

  void clearError() {
    emit(state.copyWith(
      status: ProductDetailStatus.loaded,
      errorMessage: '',
    ));
  }
}
