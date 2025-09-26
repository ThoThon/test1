import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../cart/cubit/cart_cubit.dart';
import '../../cart/cubit/cart_state.dart';
import '../cubit/mainpage_cubit.dart';
import '../cubit/mainpage_state.dart';
import '../widgets/product_card.dart';

class MainpageScreen extends StatelessWidget {
  const MainpageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MainpageCubit(),
        ),
        BlocProvider(
          create: (context) => CartCubit(),
        ),
      ],
      child: const MainpageScreenView(),
    );
  }
}

class MainpageScreenView extends StatelessWidget {
  const MainpageScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainpageCubit, MainpageState>(
      listener: (context, state) {
        if (state.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Column(
          children: [
            // Header với icon thêm sản phẩm
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Danh sách sản phẩm",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  // Icon thêm sản phẩm (+)
                  IconButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/product-create'),
                    icon: const Icon(
                      Icons.add_circle_outline,
                      size: 30,
                      color: Color(0xFFf24e1e),
                    ),
                  ),
                ],
              ),
            ),

            // Danh sách sản phẩm
            Expanded(
              child: BlocBuilder<MainpageCubit, MainpageState>(
                builder: (context, state) {
                  if (state.products.isEmpty && state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFf24e1e),
                      ),
                    );
                  }

                  if (state.products.isEmpty && !state.isLoading) {
                    return _buildEmptyState(context);
                  }

                  return SmartRefresher(
                    controller: context.read<MainpageCubit>().refreshController,
                    enablePullDown: true,
                    enablePullUp: true,
                    onRefresh: () => context.read<MainpageCubit>().onRefresh(),
                    onLoading: () => context.read<MainpageCubit>().onLoadMore(),
                    header: _buildRefreshHeader(),
                    footer: _buildLoadMoreFooter(),
                    child: _buildProductGrid(state.products),
                  );
                },
              ),
            ),
          ],
        ),

        // FloatingActionButton thành giỏ hàng
        floatingActionButton: BlocBuilder<CartCubit, CartState>(
          builder: (context, cartState) {
            final count = cartState.totalItems;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                FloatingActionButton(
                  onPressed: () => Navigator.pushNamed(context, '/cart'),
                  backgroundColor: const Color(0xFFf24e1e),
                  child: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                if (count > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Text(
                        count > 99 ? '99+' : count.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            "Chưa có sản phẩm nào",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Nhấn nút + để thêm sản phẩm mới",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.read<MainpageCubit>().onRefresh(),
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text(
              "Làm mới",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFf24e1e),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefreshHeader() {
    return const WaterDropHeader(
      waterDropColor: Color(0xFFf24e1e),
      complete: Icon(
        Icons.done,
        color: Color(0xFFf24e1e),
      ),
    );
  }

  Widget _buildLoadMoreFooter() {
    return CustomFooter(
      builder: (BuildContext context, LoadStatus? mode) {
        Widget body;
        switch (mode) {
          case LoadStatus.idle:
            body = const Text("Kéo lên để tải thêm",
                style: TextStyle(color: Colors.grey));
            break;
          case LoadStatus.loading:
            body = const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: Color(0xFFf24e1e),
                    strokeWidth: 2,
                  ),
                ),
                SizedBox(width: 8),
                Text("Đang tải...", style: TextStyle(color: Colors.grey)),
              ],
            );
            break;
          case LoadStatus.canLoading:
            body = const Text("Thả để tải thêm",
                style: TextStyle(color: Color(0xFFf24e1e)));
            break;
          default:
            body = const Text("");
            break;
        }

        return SizedBox(height: 55.0, child: Center(child: body));
      },
    );
  }

  Widget _buildProductGrid(List products) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          key: ValueKey(product.id),
        );
      },
    );
  }
}
