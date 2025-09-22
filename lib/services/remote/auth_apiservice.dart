import '../../features/login/models/login_response.dart';
import 'base_response.dart';
import 'dio_client.dart';

class AuthApiService {
  static Future<BaseResponse<LoginResponse>> login({
    required String taxCode,
    required String username,
    required String password,
  }) async {
    final response = await DioClient.dio.post(
      '/login2',
      data: {
        'tax_code': int.tryParse(taxCode),
        'user_name': username,
        'password': password,
      },
    );

    return BaseResponse<LoginResponse>.fromJson(
      response.data,
      func: (json) => LoginResponse.fromJson(json),
    );
  }
}
