import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio = Dio();

  final String _defaultBaseUrl = 'https://fake-api.tractian.com';

  DioClient() {
    _dio.options.baseUrl = _defaultBaseUrl;
  }

  Future<Response<T>> get<T>(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
    String? overrideBaseUrl,
  }) async {
    try {
      if (overrideBaseUrl != null) {
        _dio.options.baseUrl = overrideBaseUrl;
      }

      final response = await _dio.get<T>(
        url,
        options: Options(
          headers: headers,
        ),
        queryParameters: params,
      );

      if (overrideBaseUrl != null) {
        _dio.options.baseUrl = _defaultBaseUrl;
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
