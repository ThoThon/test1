import '../../features/product_list_page/models/product_model.dart';
import 'base_response.dart';
import 'base_response_list.dart';
import 'dio_client.dart';

class ProductApiService {
  static Future<BaseResponseList<Product>> getProducts({
    required int page,
    int size = 10,
  }) async {
    final response = await DioClient.dio.get(
      "/products?page=$page&size=$size",
    );

    return BaseResponseList<Product>.fromJson(
      response.data,
      func: (json) => Product.fromJson(json),
    );
  }

  // API tạo sản phẩm mới
  static Future<BaseResponse<Product>> createProduct({
    required String name,
    required int price,
    required int quantity,
    required String cover,
  }) async {
    final response = await DioClient.dio.post(
      "/products",
      data: {
        'name': name,
        'price': price,
        'quantity': quantity,
        'cover': cover,
      },
    );

    return BaseResponse<Product>.fromJson(
      response.data,
      func: (json) => Product.fromJson(json),
    );
  }

  // API chi tiết sản phẩm
  static Future<BaseResponse<Product>> getProductDetail({
    required int productId,
  }) async {
    final response = await DioClient.dio.get(
      "/products/$productId",
    );

    return BaseResponse<Product>.fromJson(
      response.data,
      func: (json) => Product.fromJson(json),
    );
  }

  // API cập nhật sản phẩm
  static Future<BaseResponse<Product>> updateProduct({
    required int productId,
    required String name,
    required int price,
    required int quantity,
    required String cover,
  }) async {
    final response = await DioClient.dio.put(
      "/products/$productId",
      data: {
        'name': name,
        'price': price,
        'quantity': quantity,
        'cover': cover,
      },
    );

    return BaseResponse<Product>.fromJson(
      response.data,
      func: (json) => Product.fromJson(json),
    );
  }

  // API xóa sản phẩm
  static Future<BaseResponse<dynamic>> deleteProduct({
    required int productId,
  }) async {
    final response = await DioClient.dio.delete(
      "/products/$productId",
    );

    return BaseResponse<dynamic>.fromJson(response.data);
  }
}
