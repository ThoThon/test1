import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ProductEditDialog extends StatefulWidget {
  final int productId;
  final String currentName;
  final int currentPrice;
  final int currentQuantity;
  final String currentCover;
  final Function(String name, int price, int quantity, String cover) onSave;

  const ProductEditDialog({
    super.key,
    required this.productId,
    required this.currentName,
    required this.currentPrice,
    required this.currentQuantity,
    required this.currentCover,
    required this.onSave,
  });

  @override
  State<ProductEditDialog> createState() => _ProductEditDialogState();
}

class _ProductEditDialogState extends State<ProductEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.currentName);
  late final _priceController =
      TextEditingController(text: widget.currentPrice.toString());

  late final _quantityController =
      TextEditingController(text: widget.currentQuantity.toString());

  late final _coverController =
      TextEditingController(text: widget.currentCover);

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _coverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text(
        "Sửa thông tin sản phẩm",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFFf24e1e),
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(
                controller: _nameController,
                label: "Tên sản phẩm",
                icon: Icons.shopping_bag_outlined,
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
              const SizedBox(height: 16),
              _buildTextField(
                controller: _priceController,
                label: "Giá bán (VNĐ)",
                icon: Icons.attach_money,
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
              const SizedBox(height: 16),
              _buildTextField(
                controller: _quantityController,
                label: "Số lượng",
                icon: Icons.inventory_2_outlined,
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
              const SizedBox(height: 16),
              _buildTextField(
                controller: _coverController,
                label: "Đường dẫn ảnh",
                icon: Icons.image_outlined,
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
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text(
            "Hủy",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFf24e1e),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  "Lưu",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: const Color(0xFFf24e1e),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFf24e1e), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        fillColor: Colors.grey[50],
        filled: true,
        labelStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 16,
        ),
        floatingLabelStyle: const TextStyle(
          color: Color(0xFFf24e1e),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      try {
        final name = _nameController.text.trim();
        final price = int.parse(_priceController.text.trim());
        final quantity = int.parse(_quantityController.text.trim());
        final cover = _coverController.text.trim();

        await widget.onSave(name, price, quantity, cover);

        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        print('Lỗi khi lưu: $e');
        if (mounted) {
          Get.snackbar(
            "Lỗi",
            "Có lỗi xảy ra khi cập nhật sản phẩm",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }
}
