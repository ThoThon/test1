import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../repositories/product_repository.dart';

class ProductCreateController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController coverController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    coverController.dispose();
    super.onClose();
  }

  Future<void> createProduct() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final name = nameController.text.trim();
      final price = int.parse(priceController.text.trim());
      final quantity = int.parse(quantityController.text.trim());
      final cover = coverController.text.trim();

      final newProduct = await ProductRepository.createProduct(
        name: name,
        price: price,
        quantity: quantity,
        cover: cover,
      );

      if (newProduct != null) {
        _showSuccessDialog("Tạo sản phẩm thành công!", onConfirm: () {
          Get.until(ModalRoute.withName('/home')); // Quay về màn home
        });
      } else {
        errorMessage.value = "Tạo sản phẩm thất bại";
        _showErrorDialog("Tạo sản phẩm thất bại");
      }
    } catch (e) {
      print('Lỗi createProduct: $e');
      errorMessage.value = "Có lỗi xảy ra khi tạo sản phẩm";
      _showErrorDialog("Có lỗi xảy ra khi tạo sản phẩm");
    } finally {
      isLoading.value = false;
    }
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
