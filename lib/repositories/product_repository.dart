import '../features/product_list_page/models/product_model.dart';
import '../services/remote/product_apiservice.dart';

class ProductRepository {
  static Future<({List<Product> products, bool hasMore})> getProducts({
    required int page,
    int size = 10,
  }) async {
    try {
      final response = await ProductApiService.getProducts(
        page: page,
        size: size,
      );

      if (response.success) {
        return (
          products: response.data,
          hasMore: response.hasMoreData(size),
        );
      }

      return (products: <Product>[], hasMore: false);
    } catch (e) {
      print('Lỗi trong ProductRepository.getProducts: $e');
      return (products: <Product>[], hasMore: false);
    }
  }

  // Lấy chi tiết sản phẩm
  static Future<Product?> getProductDetail({
    required int productId,
  }) async {
    try {
      final response = await ProductApiService.getProductDetail(
        productId: productId,
      );

      if (response.success && response.data != null) {
        return response.data!;
      }

      return null;
    } catch (e) {
      print('Lỗi trong ProductRepository.getProductDetail: $e');
      return null;
    }
  }

  // Tạo sản phẩm mới
  static Future<Product?> createProduct({
    required String name,
    required int price,
    required int quantity,
    required String cover,
  }) async {
    try {
      final response = await ProductApiService.createProduct(
        name: name,
        price: price,
        quantity: quantity,
        cover: cover,
      );

      if (response.success && response.data != null) {
        return response.data!;
      }

      return null;
    } catch (e) {
      print('Lỗi trong ProductRepository.createProduct: $e');
      return null;
    }
  }

  // Cập nhật sản phẩm
  static Future<Product?> updateProduct({
    required int productId,
    required String name,
    required int price,
    required int quantity,
    required String cover,
  }) async {
    try {
      final response = await ProductApiService.updateProduct(
        productId: productId,
        name: name,
        price: price,
        quantity: quantity,
        cover: cover,
      );

      if (response.success && response.data != null) {
        return response.data!;
      }

      return null;
    } catch (e) {
      print('Lỗi trong ProductRepository.updateProduct: $e');
      return null;
    }
  }

  // Xóa sản phẩm
  static Future<bool> deleteProduct({
    required int productId,
  }) async {
    try {
      final response = await ProductApiService.deleteProduct(
        productId: productId,
      );

      return response.success;
    } catch (e) {
      print('Lỗi trong ProductRepository.deleteProduct: $e');
      return false;
    }
  }
}
