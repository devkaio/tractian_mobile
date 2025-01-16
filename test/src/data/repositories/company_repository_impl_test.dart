import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tractian_mobile/src/data/api/dio_client.dart';
import 'package:tractian_mobile/src/data/repositories/company_repository_impl.dart';
import 'package:tractian_mobile/src/domain/entities/company.dart';
import 'package:tractian_mobile/src/domain/failures/repository_failures.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  late MockDioClient mockDioClient;
  late CompanyRepositoryImpl companyRepository;

  setUp(() {
    mockDioClient = MockDioClient();
    companyRepository = CompanyRepositoryImpl(mockDioClient);
  });

  group('CompanyRepositoryImpl', () {
    test('should return a list of companies when the API call is successful',
        () async {
      final mockResponse = [
        {"id": "1", "name": "Jaguar"},
        {"id": "2", "name": "Tobias"},
      ];

      when(() => mockDioClient.get('/companies')).thenAnswer(
        (_) async => Response(
          data: mockResponse,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await companyRepository.getCompanies();

      expect(result.data, isNotNull);
      expect(result.error, isNull);
      expect(result.data!.length, 2);
      expect(result.data!.first, isA<Company>());
      expect(result.data!.first.id, '1');
      expect(result.data!.first.name, 'Jaguar');
    });

    test('should return failure when the API call fails', () async {
      when(() => mockDioClient.get('/companies'))
          .thenThrow(Exception('Network error'));

      final result = await companyRepository.getCompanies();

      expect(result.data, isNull);
      expect(result.error, isA<CompanyFailure>());
    });
  });
}
