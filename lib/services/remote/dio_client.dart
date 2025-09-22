import 'package:dio/dio.dart';

import '../../config/app_config.dart';
import 'access_token_interceptor.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  )..interceptors.add(AccessTokenInterceptor());
}
