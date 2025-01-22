import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tractian_mobile/src/data/api/dio_client.dart';
import 'package:tractian_mobile/src/data/repositories/location_repository_impl.dart';
import 'package:tractian_mobile/src/domain/failures/repository_failures.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  late MockDioClient mockDioClient;
  late LocationRepositoryImpl locationRepository;

  setUp(() {
    mockDioClient = MockDioClient();
    locationRepository = LocationRepositoryImpl(mockDioClient);
  });

  group('LocationRepositoryImpl', () {
    test('should return a list of locations when the API call is successful',
        () async {
      final companyId = '123';
      final mockResponse = [
        {"id": "1", "name": "Location A", "parentId": null},
        {"id": "2", "name": "Location B", "parentId": "1"},
      ];

      when(() => mockDioClient.get('/companies/$companyId/locations'))
          .thenAnswer(
        (_) async => Response(
          data: mockResponse,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await locationRepository.fetchLocations(companyId);

      expect(result.data, isNotNull);
      expect(result.error, isNull);
      expect(result.data!.length, 2);
      expect(result.data?.first.id, '1');
      expect(result.data?.first.name, 'Location A');
    });

    test('should return failure when the API call fails', () async {
      final companyId = '123';

      when(() => mockDioClient.get('/companies/$companyId/locations'))
          .thenThrow(Exception('Network error'));

      final result = await locationRepository.fetchLocations(companyId);

      expect(result.data, isNull);
      expect(result.error, isA<LocationFailure>());
    });
  });
}
