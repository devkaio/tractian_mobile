import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tractian_mobile/src/data/api/dio_client.dart';

import '../data_mocks.dart';

void main() {
  late DioClient dioClient;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dioClient = DioClient(mockDio);

    // Mock the options getter to return a valid BaseOptions instance
    when(() => mockDio.options).thenReturn(BaseOptions(
      baseUrl: 'https://fake-api.tractian.com',
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
    ));
  });

  group('DioClient', () {
    test('should perform a GET request and return the response', () async {
      final url = '/test';
      final response = Response(
        requestOptions: RequestOptions(path: url),
        data: 'response data',
        statusCode: 200,
      );

      when(() => mockDio.get<String>(
            any(),
            options: any(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => response);

      final result = await dioClient.get<String>(url);

      expect(result, isNotNull);
      expect(result.data, equals('response data'));
      expect(result.statusCode, equals(200));

      verify(() => mockDio.get<String>(
            url,
            options: any(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
          )).called(1);
    });

    test('should throw an exception when the GET request fails', () async {
      final url = '/test';
      final exception = DioException(
        requestOptions: RequestOptions(path: url),
        error: 'error',
      );

      when(() => mockDio.get<String>(
            any(),
            options: any(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
          )).thenThrow(exception);

      expect(
        () async => await dioClient.get<String>(url),
        throwsA(isA<DioException>()),
      );

      verify(() => mockDio.get<String>(
            url,
            options: any(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
          )).called(1);
    });
  });
}
