import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controller/product_create_controller.dart';
import '../widget/input_field.dart';

class ProductCreateScreen extends GetView<ProductCreateController> {
  const ProductCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Thêm sản phẩm mới",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Tên sản phẩm
                InputField(
                  controller: controller.nameController,
                  label: "Tên sản phẩm",
                  icon: Icons.shopping_bag_outlined,
                  hintText: "Nhập tên sản phẩm",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Tên sản phẩm không được để trống';
                    }
                    if (value.trim().length < 3) {
                      return 'Tên sản phẩm phải có ít nhất 3 ký tự';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Giá bán
                InputField(
                  controller: controller.priceController,
                  label: "Giá bán (VNĐ)",
                  icon: Icons.attach_money,
                  hintText: "Nhập giá bán",
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Giá bán không được để trống';
                    }
                    final price = int.tryParse(value);
                    if (price == null || price <= 0) {
                      return 'Giá bán phải là số nguyên dương';
                    }
                    if (price > 999999999) {
                      return 'Giá bán không được vượt quá 999,999,999 VNĐ';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Số lượng
                InputField(
                  controller: controller.quantityController,
                  label: "Số lượng",
                  icon: Icons.inventory_2_outlined,
                  hintText: "Nhập số lượng",
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Số lượng không được để trống';
                    }
                    final quantity = int.tryParse(value);
                    if (quantity == null || quantity < 0) {
                      return 'Số lượng phải là số nguyên không âm';
                    }
                    if (quantity > 999999) {
                      return 'Số lượng không được vượt quá 999,999';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Đường dẫn ảnh
                InputField(
                  controller: controller.coverController,
                  label: "Đường dẫn ảnh",
                  icon: Icons.image_outlined,
                  hintText: "Nhập URL hình ảnh",
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Đường dẫn ảnh không được để trống';
                    }
                    // Kiểm tra URL đơn giản
                    final urlPattern = r'^https?://';
                    if (!RegExp(urlPattern).hasMatch(value.trim())) {
                      return 'Đường dẫn ảnh phải bắt đầu với http:// hoặc https://';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                // Nút tạo sản phẩm
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.createProduct,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFf24e1e),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: controller.isLoading.value
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    "Đang tạo...",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                            : const Text(
                                "Tạo sản phẩm",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    )),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
