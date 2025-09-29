import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/product_detail_cubit.dart';
import '../cubit/product_detail_state.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get productId from route arguments (nullable)
    final int? productId = ModalRoute.of(context)?.settings.arguments as int?;

    return BlocProvider(
      create: (context) => ProductDetailCubit(productId: productId),
      child: const ProductDetailView(),
    );
  }
}

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _coverController = TextEditingController();

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
    return BlocConsumer<ProductDetailCubit, ProductDetailState>(
      listener: (context, state) {
        // Populate form when product is loaded (edit mode)
        if (state.status == ProductDetailStatus.loaded &&
            state.product != null &&
            state.isEditMode) {
          _nameController.text = state.product!.name;
          _priceController.text = state.product!.price.toString();
          _quantityController.text = state.product!.quantity.toString();
          _coverController.text = state.product!.cover;
        }

        // Show success dialog when saved
        if (state.status == ProductDetailStatus.saved) {
          _showSuccessDialog(
            context,
            state.isEditMode
                ? "Cập nhật sản phẩm thành công!"
                : "Tạo sản phẩm thành công!",
          );
        }

        // Show success dialog when deleted
        if (state.status == ProductDetailStatus.deleted) {
          _showSuccessDialog(
            context,
            "Xóa sản phẩm thành công!",
            popTwice: true,
          );
        }

        // Show error dialog
        if (state.status == ProductDetailStatus.error &&
            state.errorMessage.isNotEmpty) {
          _showErrorDialog(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              state.isEditMode ? "Chi tiết sản phẩm" : "Thêm sản phẩm mới",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: Colors.white,
            elevation: 1,
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ProductDetailState state) {
    if (state.status == ProductDetailStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFf24e1e),
        ),
      );
    }

    if (state.status == ProductDetailStatus.error &&
        state.product == null &&
        state.isEditMode) {
      return _buildErrorView(context, state);
    }

    return _buildForm(context, state);
  }

  Widget _buildErrorView(BuildContext context, ProductDetailState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            state.errorMessage,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () =>
                context.read<ProductDetailCubit>().fetchProductDetail(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFf24e1e),
              foregroundColor: Colors.white,
            ),
            child: const Text("Thử lại"),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context, ProductDetailState state) {
    final isLoading = state.status == ProductDetailStatus.saving ||
        state.status == ProductDetailStatus.deleting;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Show product image if in edit mode
              if (state.isEditMode && state.product != null) ...[
                _buildProductImage(state.product!.cover),
                const SizedBox(height: 24),
              ],

              const SizedBox(height: 16),

              // Name field
              _buildInputField(
                controller: _nameController,
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

              // Price field
              _buildInputField(
                controller: _priceController,
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

              // Quantity field
              _buildInputField(
                controller: _quantityController,
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

              // Cover URL field
              _buildInputField(
                controller: _coverController,
                label: "Đường dẫn ảnh",
                icon: Icons.image_outlined,
                hintText: "Nhập URL hình ảnh",
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Đường dẫn ảnh không được để trống';
                  }
                  final urlPattern = r'^https?://';
                  if (!RegExp(urlPattern).hasMatch(value.trim())) {
                    return 'Đường dẫn ảnh phải bắt đầu với http:// hoặc https://';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              // Save button (Create mode) or Action buttons (Edit mode)
              if (state.isEditMode) ...[
                // Edit mode: Update and Delete buttons side by side
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed:
                            isLoading ? null : () => _handleSave(context),
                        icon: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.edit,
                                size: 20, color: Colors.white),
                        label: Text(
                          isLoading ? "Đang xử lý..." : "Sửa thông tin",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed:
                            isLoading ? null : () => _handleDelete(context),
                        icon: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.delete,
                                size: 20, color: Colors.white),
                        label: Text(
                          isLoading ? "Đang xử lý..." : "Xóa sản phẩm",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                // Create mode: Single create button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : () => _handleSave(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFf24e1e),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: isLoading
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
                ),
              ],

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(String coverUrl) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          coverUrl,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Không thể tải ảnh",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hintText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(
              icon,
              color: const Color(0xFFf24e1e),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFf24e1e),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            fillColor: Colors.grey[50],
            filled: true,
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  void _handleSave(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final price = int.parse(_priceController.text.trim());
      final quantity = int.parse(_quantityController.text.trim());
      final cover = _coverController.text.trim();

      context.read<ProductDetailCubit>().saveProduct(
            name: name,
            price: price,
            quantity: quantity,
            cover: cover,
          );
    }
  }

  void _handleDelete(BuildContext context) {
    context.read<ProductDetailCubit>().deleteProduct(context);
  }

  void _showSuccessDialog(
    BuildContext context,
    String message, {
    bool popTwice = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text(
          "Thành công",
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext); // Close dialog
              Navigator.pop(context); // Go back to previous screen
              if (popTwice) {
                // For delete action, go back to home
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(
          "Lỗi",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ProductDetailCubit>().clearError();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFFf24e1e),
            ),
            child: const Text("Đóng"),
          ),
        ],
      ),
    );
  }
}
