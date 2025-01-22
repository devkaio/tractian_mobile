import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tractian_mobile/src/data/api/dio_client.dart';
import 'package:tractian_mobile/src/data/repositories/asset_repository_impl.dart';
import 'package:tractian_mobile/src/domain/entities/asset.dart';

// Mock class
class MockDioClient extends Mock implements DioClient {}

void main() {
  late MockDioClient mockDioClient;
  late AssetRepositoryImpl assetRepository;

  setUp(() {
    mockDioClient = MockDioClient();
    assetRepository = AssetRepositoryImpl(mockDioClient);
  });

  group('AssetRepositoryImpl', () {
    test('should return a list of assets when the API call is successful',
        () async {
      // Arrange
      final companyId = '123';
      final mockResponse = [
        {
          "id": "1",
          "name": "Asset 1",
          "sensorType": "energy",
        },
        {
          "id": "2",
          "name": "Asset 2",
          "sensorType": "vibration",
        },
      ];

      when(() => mockDioClient.get('/companies/$companyId/assets')).thenAnswer(
        (_) async => Response(
          data: mockResponse,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // Act
      final result = await assetRepository.fetchAssets(companyId);

      // Assert
      expect(result.data, isNotNull);
      expect(result.error, isNull);
      expect(result.data!.length, 2);
      expect(result.data!.first, isA<Asset>());
      expect(result.data!.first.id, '1');
      expect(result.data!.first.name, 'Asset 1');
    });

    test('should return failure when the API call fails', () async {
      // Arrange
      final companyId = '123';

      when(() => mockDioClient.get('/companies/$companyId/assets'))
          .thenThrow(Exception('Network error'));

      // Act
      final result = await assetRepository.fetchAssets(companyId);

      // Assert
      expect(result.data, isNull);
      expect(result.error, isNotNull);
    });
  });
}
