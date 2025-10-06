import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/product_detail_cubit.dart';
import '../cubit/product_detail_state.dart';
import '../widgets/input_field.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int? productId = ModalRoute.of(context)?.settings.arguments as int?;

    return BlocProvider(
      create: (context) => ProductDetailCubit(productId: productId),
      child: const _ProductDetailView(),
    );
  }
}

class _ProductDetailView extends StatefulWidget {
  const _ProductDetailView();

  @override
  State<_ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<_ProductDetailView> {
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
        // Load product data vào form
        if (state.status == ProductDetailStatus.loaded &&
            state.product != null &&
            state.isEditMode) {
          _nameController.text = state.product!.name;
          _priceController.text = state.product!.price.toString();
          _quantityController.text = state.product!.quantity.toString();
          _coverController.text = state.product!.cover;
        }

        // Show delete dialog
        if (state.showDeleteDialog) {
          context.read<ProductDetailCubit>().deleteDialogShown();
          _showConfirmDeleteDialog(context);
        }

        // Saved
        if (state.status == ProductDetailStatus.saved) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.isEditMode
                    ? "Cập nhật sản phẩm thành công!"
                    : "Tạo sản phẩm thành công!",
              ),
              backgroundColor: Colors.green,
            ),
          );
        }

        // Deleted
        if (state.status == ProductDetailStatus.deleted) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Xóa sản phẩm thành công!"),
              backgroundColor: Colors.green,
            ),
          );
        }

        // Error
        if (state.status == ProductDetailStatus.error &&
            state.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
          context.read<ProductDetailCubit>().clearError();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              state.isEditMode ? "Chi tiết sản phẩm" : "Thêm sản phẩm mới",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
        child: CircularProgressIndicator(color: Color(0xFFf24e1e)),
      );
    }

    if (state.status == ProductDetailStatus.error &&
        state.product == null &&
        state.isEditMode) {
      return Center(
        child: Text("Lỗi: ${state.errorMessage}"),
      );
    }

    return _buildForm(context, state);
  }

  Widget _buildForm(BuildContext context, ProductDetailState state) {
    final isLoading = state.status == ProductDetailStatus.saving ||
        state.status == ProductDetailStatus.deleting;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            if (state.isEditMode && state.product != null) ...[
              _buildProductImage(state.product!.cover),
              const SizedBox(height: 24),
            ],
            InputField(
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
            InputField(
              controller: _priceController,
              label: "Giá bán (VNĐ)",
              icon: Icons.attach_money,
              hintText: "Nhập giá bán",
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 20),
            InputField(
              controller: _quantityController,
              label: "Số lượng",
              icon: Icons.inventory_2_outlined,
              hintText: "Nhập số lượng",
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 20),
            InputField(
              controller: _coverController,
              label: "Đường dẫn ảnh",
              icon: Icons.image_outlined,
              hintText: "Nhập URL hình ảnh",
              maxLines: 2,
            ),
            const SizedBox(height: 30),
            state.isEditMode
                ? Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              isLoading ? null : () => _handleSave(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                              isLoading ? "Đang xử lý..." : "Sửa thông tin"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  context
                                      .read<ProductDetailCubit>()
                                      .requestDelete();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                              isLoading ? "Đang xử lý..." : "Xóa sản phẩm"),
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : () => _handleSave(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFf24e1e),
                        foregroundColor: Colors.white,
                      ),
                      child: Text(isLoading ? "Đang tạo..." : "Tạo sản phẩm"),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(url, height: 300, fit: BoxFit.cover),
    );
  }

  void _handleSave(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ProductDetailCubit>().saveProduct(
            name: _nameController.text.trim(),
            price: int.parse(_priceController.text.trim()),
            quantity: int.parse(_quantityController.text.trim()),
            cover: _coverController.text.trim(),
          );
    }
  }

  Future<void> _showConfirmDeleteDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(
          "Xác nhận xóa",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "Bạn có chắc chắn muốn xóa sản phẩm này?\nHành động này không thể hoàn tác.",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text(
              "Hủy",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Xóa"),
          ),
        ],
      ),
    );

    if (result == true && context.mounted) {
      context.read<ProductDetailCubit>().confirmDelete();
    }
  }
}
