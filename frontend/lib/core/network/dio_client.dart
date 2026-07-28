import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/api_constants.dart';
import '../storage/secure_storage.dart';

class DioClient {
  DioClient._();

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  )
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SecureStorage.getToken();

          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] =
                "Bearer $token";
          }

          handler.next(options);
        },
      ),
    )
    ..interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        responseBody: true,
      ),
    );
}