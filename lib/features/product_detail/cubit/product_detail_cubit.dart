import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/product_repository.dart';
import 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final int? productId;

  // Text controllers
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final coverController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  ProductDetailCubit({this.productId}) : super(const ProductDetailState()) {
    if (productId != null) {
      // Edit mode - fetch product detail
      fetchProductDetail();
    } else {
      // Create mode
      emit(state.copyWith(
        getProductDetailStatus: LoadingStatus.loaded,
        isEditMode: false,
      ));
    }
  }

  Future<void> fetchProductDetail() async {
    emit(state.copyWith(
      getProductDetailStatus: LoadingStatus.loading,
      isEditMode: true,
    ));

    try {
      final product = await ProductRepository.getProductDetail(
        productId: productId!,
      );

      if (product != null) {
        // Load data vào controllers
        nameController.text = product.name;
        priceController.text = product.price.toString();
        quantityController.text = product.quantity.toString();
        coverController.text = product.cover;

        emit(state.copyWith(
          getProductDetailStatus: LoadingStatus.loaded,
          product: product,
        ));
      } else {
        emit(state.copyWith(
          getProductDetailStatus: LoadingStatus.error,
          errorMessage: "Không tìm thấy thông tin sản phẩm",
        ));
      }
    } catch (e) {
      print('Lỗi fetchProductDetail: $e');
      emit(state.copyWith(
        getProductDetailStatus: LoadingStatus.error,
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
    emit(state.copyWith(saveProductStatus: LoadingStatus.loading));

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
            saveProductStatus: LoadingStatus.loaded,
            product: updatedProduct,
          ));
        } else {
          emit(state.copyWith(
            saveProductStatus: LoadingStatus.error,
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
            saveProductStatus: LoadingStatus.loaded,
            product: newProduct,
          ));
        } else {
          emit(state.copyWith(
            saveProductStatus: LoadingStatus.error,
            errorMessage: "Tạo sản phẩm thất bại",
          ));
        }
      }
    } catch (e) {
      print('Lỗi saveProduct: $e');
      emit(state.copyWith(
        saveProductStatus: LoadingStatus.error,
        errorMessage: state.isEditMode
            ? "Có lỗi xảy ra khi cập nhật sản phẩm"
            : "Có lỗi xảy ra khi tạo sản phẩm",
      ));
    }
  }

  Future<void> saveProductFromForm() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    await saveProduct(
      name: nameController.text.trim(),
      price: int.parse(priceController.text.trim()),
      quantity: int.parse(quantityController.text.trim()),
      cover: coverController.text.trim(),
    );
  }

  Future<void> confirmDelete() async {
    if (productId == null) return;

    emit(state.copyWith(deleteProductStatus: LoadingStatus.loading));

    try {
      final success = await ProductRepository.deleteProduct(
        productId: productId!,
      );

      if (success) {
        emit(state.copyWith(deleteProductStatus: LoadingStatus.loaded));
      } else {
        emit(state.copyWith(
          deleteProductStatus: LoadingStatus.error,
          errorMessage: "Xóa sản phẩm thất bại",
        ));
      }
    } catch (e) {
      print('Lỗi deleteProduct: $e');
      emit(state.copyWith(
        deleteProductStatus: LoadingStatus.error,
        errorMessage: "Có lỗi xảy ra khi xóa sản phẩm",
      ));
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    coverController.dispose();
    return super.close();
  }
}
