import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cart/cubit/cart_cubit.dart';
import '../../cart/cubit/cart_state.dart';
import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh sản phẩm
          Expanded(
            child: InkWell(
              onTap: () async {
                // QUAN TRỌNG: Navigate đúng cách
                await Navigator.pushNamed(
                  context,
                  '/product-detail',
                  arguments: product.id,
                );
                // Reload cart sau khi quay về
                if (context.mounted) {
                  context.read<CartCubit>().loadCartItems();
                }
              },
              child: Image.network(
                product.cover,
                width: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
          ),

          // Thông tin sản phẩm
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên sản phẩm
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),

                // Giá và số lượng
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        "${product.price} VNĐ",
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: const Color(0xFFf24e1e),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "SL: ${product.quantity}",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Button thêm/xóa giỏ hàng
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: BlocBuilder<CartCubit, CartState>(
                    builder: (context, state) {
                      final isInCart = state.cartItems
                          .any((item) => item.productId == product.id);

                      return ElevatedButton.icon(
                        onPressed: product.quantity > 0
                            ? () {
                                if (isInCart) {
                                  context
                                      .read<CartCubit>()
                                      .removeFromCart(product.id);
                                } else {
                                  context.read<CartCubit>().addToCart(product);
                                }
                              }
                            : null,
                        icon: Icon(
                          isInCart
                              ? Icons.remove_shopping_cart
                              : Icons.add_shopping_cart,
                          size: 16,
                          color: Colors.white,
                        ),
                        label: Text(
                          isInCart ? "Xóa khỏi giỏ" : "Thêm vào giỏ",
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: product.quantity > 0
                              ? (isInCart
                                  ? Colors.orange
                                  : const Color(0xFFf24e1e))
                              : Colors.grey,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
