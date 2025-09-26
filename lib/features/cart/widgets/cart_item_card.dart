import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cart_cubit.dart';
import '../models/cart_item.dart';

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;

  const CartItemCard({
    super.key,
    required this.cartItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Ảnh sản phẩm
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  cartItem.cover,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 12),

              // Thông tin sản phẩm
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${cartItem.price} VNĐ",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFf24e1e),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Nút xóa
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            _showDeleteConfirmDialog(context, cartItem);
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext parentContext, CartItem cartItem) {
    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text(
          "Xác nhận xóa",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Bạn có chắc chắn muốn xóa ${cartItem.name} khỏi giỏ hàng?",
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              "Hủy",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Sử dụng parentContext để truy cập CartCubit
              BlocProvider.of<CartCubit>(parentContext)
                  .removeFromCart(cartItem.productId);
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Xóa"),
          ),
        ],
      ),
    );
  }
}
