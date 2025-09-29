import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../repositories/product_repository.dart';
import '../../mainpage/models/product_model.dart';

class ProductDetailController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<Product?> productDetail = Rx<Product?>(null);

  final int productId = Get.arguments;

  @override
  void onInit() {
    super.onInit();
    fetchProductDetail();
  }

  Future<void> fetchProductDetail() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final detail = await ProductRepository.getProductDetail(
        productId: productId,
      );

      if (detail != null) {
        productDetail.value = detail;
      } else {
        errorMessage.value = "Không tìm thấy thông tin sản phẩm";
      }
    } catch (e) {
      print('Lỗi fetchProductDetail: $e');
      errorMessage.value = "Có lỗi xảy ra khi tải dữ liệu";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProduct({
    required String name,
    required int price,
    required int quantity,
    required String cover,
  }) async {
    isLoading.value = true;

    try {
      final updatedProduct = await ProductRepository.updateProduct(
        productId: productId,
        name: name,
        price: price,
        quantity: quantity,
        cover: cover,
      );

      if (updatedProduct != null) {
        productDetail.value = updatedProduct;
        _showSuccessDialog("Cập nhật sản phẩm thành công!");
      } else {
        _showErrorDialog("Cập nhật sản phẩm thất bại");
      }
    } catch (e) {
      print('Lỗi updateProduct: $e');
      _showErrorDialog("Có lỗi xảy ra khi cập nhật sản phẩm");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct() async {
    final confirmed = await _showConfirmDeleteDialog();
    if (!confirmed) return;

    isLoading.value = true;

    try {
      final success = await ProductRepository.deleteProduct(
        productId: productId,
      );

      if (success) {
        _showSuccessDialog(
          "Xóa sản phẩm thành công!",
          onConfirm: () {
            Get.until(ModalRoute.withName('/home'));
          },
        );
      } else {
        _showErrorDialog("Xóa sản phẩm thất bại");
      }
    } catch (e) {
      print('Lỗi deleteProduct: $e');
      _showErrorDialog("Có lỗi xảy ra khi xóa sản phẩm");
    } finally {
      isLoading.value = false;
    }
  }

  void onBackPressed() {
    Get.back();
  }

  Future<bool> _showConfirmDeleteDialog() async {
    final result = await Get.defaultDialog<bool>(
      title: "Xác nhận xóa",
      middleText:
          "Bạn có chắc chắn muốn xóa sản phẩm này?\nHành động này không thể hoàn tác.",
      backgroundColor: Colors.white,
      titleStyle:
          const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      middleTextStyle: const TextStyle(color: Colors.black),
      radius: 15,
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: const Text(
            "Hủy",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        ElevatedButton(
          onPressed: () => Get.back(result: true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text("Xóa"),
        ),
      ],
    );

    return result ?? false;
  }

  void _showSuccessDialog(String message, {VoidCallback? onConfirm}) {
    Get.defaultDialog(
      title: "Thành công",
      middleText: message,
      backgroundColor: Colors.white,
      titleStyle:
          const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      middleTextStyle: const TextStyle(color: Colors.black),
      radius: 15,
      actions: [
        ElevatedButton(
          onPressed: onConfirm ?? () => Get.back(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: const Text("OK"),
        ),
      ],
    );
  }

  void _showErrorDialog(String message) {
    Get.defaultDialog(
      title: "Lỗi",
      middleText: message,
      backgroundColor: Colors.white,
      titleStyle:
          const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      middleTextStyle: const TextStyle(color: Colors.black),
      radius: 15,
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFFf24e1e),
          ),
          child: const Text("Đóng"),
        ),
      ],
    );
  }
}
