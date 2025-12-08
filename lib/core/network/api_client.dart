import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({String baseUrl = 'https://dummyjson.com'})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

  Dio get dio => _dio;
}
