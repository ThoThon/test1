import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../repositories/product_repository.dart';
import '../../cart/models/cart_item.dart';
import '../../cart/models/cart_storage.dart';
import '../models/product_model.dart';
import 'product_list_page_state.dart';

class ProductListPageCubit extends Cubit<ProductListPageState> {
  final refreshController = RefreshController(initialRefresh: false);

  // Pagination
  var currentPage = 1;
  final int pageSize = 10;
  static const int defaultPageNumber = 1;

  ProductListPageCubit() : super(const ProductListPageState()) {
    fetchProducts();
  }

  @override
  Future<void> close() {
    refreshController.dispose();
    return super.close();
  }

  /// Lấy danh sách sản phẩm
  Future<void> fetchProducts({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      emit(state.copyWith(isLoading: true));
    }

    try {
      final page = isLoadMore ? currentPage + 1 : defaultPageNumber;

      final result = await ProductRepository.getProducts(
        page: page,
        size: pageSize,
      );

      // Cập nhật isInCart cho từng sản phẩm
      final productsWithCartStatus = result.products.map((product) {
        final isInCart = CartStorage.isInCart(product.id);
        return product.copyWith(isInCart: isInCart);
      }).toList();

      final List<Product> newProducts;
      if (isLoadMore) {
        newProducts = [...state.products, ...productsWithCartStatus];
      } else {
        newProducts = productsWithCartStatus;
      }

      emit(state.copyWith(
        products: newProducts,
      ));

      // Chỉ cập nhật currentPage khi load thành công
      currentPage = page;
    } catch (e) {
      print("Lỗi fetchProducts: $e");
      _showErrorSnackbar("Có lỗi xảy ra khi tải dữ liệu");
    } finally {
      // Xử lý isLoading và refresh controller ở finally
      if (isLoadMore) {
        refreshController.loadComplete();
      } else {
        emit(state.copyWith(isLoading: false));
        refreshController.refreshCompleted();
      }
    }
  }

  /// Pull to refresh
  Future<void> onRefresh() async {
    await fetchProducts(isLoadMore: false);
  }

  /// Load more
  Future<void> onLoadMore() async {
    await fetchProducts(isLoadMore: true);
  }

  /// Thêm sản phẩm vào giỏ hàng
  Future<void> addToCart(Product product) async {
    final cartItem = CartItem(
      productId: product.id,
      name: product.name,
      price: product.price,
      cover: product.cover,
    );
    await CartStorage.addToCart(cartItem);

    // Cập nhật lại isInCart cho sản phẩm
    _updateProductCartStatus(product.id, true);
  }

  /// Xóa sản phẩm khỏi giỏ hàng
  Future<void> removeFromCart(int productId) async {
    await CartStorage.removeFromCart(productId);

    // Cập nhật lại isInCart cho sản phẩm
    _updateProductCartStatus(productId, false);
  }

  /// Cập nhật trạng thái isInCart của sản phẩm
  void _updateProductCartStatus(int productId, bool isInCart) {
    final updatedProducts = state.products.map((product) {
      if (product.id == productId) {
        return product.copyWith(isInCart: isInCart);
      }
      return product;
    }).toList();

    final totalItems = CartStorage.itemCount;

    emit(state.copyWith(
      products: updatedProducts,
      totalCartItems: totalItems,
    ));
  }

  /// Reload cart items khi quay về từ màn khác
  void reloadCartStatus() {
    final updatedProducts = state.products.map((product) {
      final isInCart = CartStorage.isInCart(product.id);
      return product.copyWith(isInCart: isInCart);
    }).toList();

    final totalItems = CartStorage.itemCount;

    emit(state.copyWith(
      products: updatedProducts,
      totalCartItems: totalItems,
    ));
  }

  void _showErrorSnackbar(String message) {
    emit(state.copyWith(errorMessage: message));
  }
}
