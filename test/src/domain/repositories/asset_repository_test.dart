import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tractian_mobile/src/core/data_result/data_result.dart';
import 'package:tractian_mobile/src/domain/entities/asset.dart';
import 'package:tractian_mobile/src/domain/failures/repository_failures.dart';

import '../domain_mocks.dart';

void main() {
  group('AssetRepository', () {
    late MockAssetRepository mockAssetRepository;

    setUp(() {
      mockAssetRepository = MockAssetRepository();
    });

    test('should return a list of assets on success', () async {
      final assets = [
        Asset(
          id: '1',
          name: 'Fan - External',
          locationId: null,
          parentId: null,
          sensorType: 'energy',
          status: 'operating',
        ),
      ];

      when(() => mockAssetRepository.fetchAssets('company1'))
          .thenAnswer((_) async => DataResult.success(assets));

      final result = await mockAssetRepository.fetchAssets('company1');

      expect(result.data, isNotNull);
      expect(result.error, isNull);
      expect(result.data, isA<List<Asset>>());
      expect(result.data, assets);
      expect(result.data!.length, 1);
      expect(result.data!.first.name, 'Fan - External');
    });

    test('should return failure when API call fails', () async {
      when(() => mockAssetRepository.fetchAssets('company1'))
          .thenAnswer((_) async => DataResult.failure(const AssetFailure()));

      final result = await mockAssetRepository.fetchAssets('company1');

      expect(result.error, isNotNull);
      expect(result.data, isNull);
      expect(result.error, isA<AssetFailure>());
      expect(result.error, const AssetFailure());
    });
  });
}
