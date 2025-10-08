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

class _ProductDetailView extends StatelessWidget {
  const _ProductDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductDetailCubit, ProductDetailState>(
      listener: (context, state) {
        // Save success
        if (state.saveProductStatus == LoadingStatus.loaded) {
          context.read<ProductDetailCubit>().resetSaveStatus();
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

        // Delete success
        if (state.deleteProductStatus == LoadingStatus.loaded) {
          context.read<ProductDetailCubit>().resetDeleteStatus();
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Xóa sản phẩm thành công!"),
              backgroundColor: Colors.green,
            ),
          );
        }

        // Show error from any operation
        if (state.errorMessage.isNotEmpty) {
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
    // Show loading when fetching product detail
    if (state.getProductDetailStatus == LoadingStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFf24e1e)),
      );
    }

    // Show error if failed to load product detail
    if (state.getProductDetailStatus == LoadingStatus.error &&
        state.product == null &&
        state.isEditMode) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Lỗi: ${state.errorMessage}",
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFf24e1e),
              ),
              child: const Text(
                "Quay lại",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    return _buildForm(context, state);
  }

  Widget _buildForm(BuildContext context, ProductDetailState state) {
    final cubit = context.read<ProductDetailCubit>();
    final isSaving = state.saveProductStatus == LoadingStatus.loading;
    final isDeleting = state.deleteProductStatus == LoadingStatus.loading;
    final isLoading = isSaving || isDeleting;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: cubit.formKey,
        child: Column(
          children: [
            if (state.isEditMode && state.product != null) ...[
              _buildProductImage(state.product!.cover),
              const SizedBox(height: 24),
            ],
            InputField(
              controller: cubit.nameController,
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
              controller: cubit.priceController,
              label: "Giá bán (VNĐ)",
              icon: Icons.attach_money,
              hintText: "Nhập giá bán",
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 20),
            InputField(
              controller: cubit.quantityController,
              label: "Số lượng",
              icon: Icons.inventory_2_outlined,
              hintText: "Nhập số lượng",
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 20),
            InputField(
              controller: cubit.coverController,
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
                          onPressed: isLoading
                              ? null
                              : () => cubit.saveProductFromForm(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text("Sửa thông tin"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              isLoading ? null : () => _handleDelete(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: isDeleting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text("Xóa sản phẩm"),
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed:
                          isLoading ? null : () => cubit.saveProductFromForm(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFf24e1e),
                        foregroundColor: Colors.white,
                      ),
                      child: isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text("Tạo sản phẩm"),
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
      child: Image.network(
        url,
        height: 300,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 300,
            color: Colors.grey[300],
            child: const Icon(
              Icons.image_not_supported,
              size: 80,
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleDelete(BuildContext context) async {
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
