import 'package:dio/dio.dart';

class DioClient {
  static final _baseUrl = 'https://fake-api.tractian.com';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
    ),
  );

  DioClient();

  Future<Response<T>> get<T>(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
    String? overrideBaseUrl,
  }) async {
    try {
      _dio.options.baseUrl = overrideBaseUrl ?? _baseUrl;

      final response = await _dio.get<T>(
        url,
        options: Options(
          headers: headers,
        ),
        queryParameters: params,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
