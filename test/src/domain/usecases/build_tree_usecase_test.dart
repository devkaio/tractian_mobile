import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:data_result/data_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tractian_mobile/src/domain/entities/asset.dart';
import 'package:tractian_mobile/src/domain/entities/component.dart';
import 'package:tractian_mobile/src/domain/entities/location.dart';
import 'package:tractian_mobile/src/domain/entities/node.dart';
import 'package:tractian_mobile/src/domain/failures/repository_failures.dart';
import 'package:tractian_mobile/src/domain/usecases/build_tree_usecase.dart';

import '../domain_mocks.dart';

void main() {
  late BuildTreeUseCase buildTreeUseCase;
  late MockAssetRepository mockAssetRepository;
  late MockLocationRepository mockLocationRepository;

  setUp(() {
    mockAssetRepository = MockAssetRepository();
    mockLocationRepository = MockLocationRepository();
    buildTreeUseCase = BuildTreeUseCase(
      assetRepository: mockAssetRepository,
      locationRepository: mockLocationRepository,
    );
  });

  group('fetchTreeData', () {
    test(
        'should return DataResult.success with tree data when repositories return data',
        () async {
      final companyId = 'company1';
      final assets = [
        Asset(
            id: 'asset1', name: 'Asset 1', parentId: null, locationId: 'loc1'),
        Asset(
            id: 'asset2',
            name: 'Asset 2',
            parentId: 'asset1',
            locationId: 'loc1'),
      ];
      final locations = [
        Location(id: 'loc1', name: 'Location 1', parentId: null),
      ];

      when(() => mockAssetRepository.fetchAssets(companyId)).thenAnswer(
        (_) async => DataResult.success(assets),
      );
      when(() => mockLocationRepository.fetchLocations(companyId)).thenAnswer(
        (_) async => DataResult.success(locations),
      );

      final result = await buildTreeUseCase.fetchTreeData(companyId);

      expect(result.data, isNotNull);
      expect(result.data!.length, greaterThan(0));

      for (var rootNode in result.data!) {
        verifyTreeStructure(rootNode);
      }
    });

    test(
        'should return DataResult.failure when asset repository returns an error',
        () async {
      final companyId = 'company1';
      final error = AssetFailure('Error fetching assets');
      when(() => mockAssetRepository.fetchAssets(companyId))
          .thenAnswer((_) async => DataResult.failure(error));
      when(() => mockLocationRepository.fetchLocations(companyId))
          .thenAnswer((_) async => DataResult.success([]));

      final result = await buildTreeUseCase.fetchTreeData(companyId);

      expect(result.error, isNotNull);
      expect(result.data, isNull);
      expect(result.error!.message, error.message);
    });

    test(
        'should return DataResult.failure when location repository returns an error',
        () async {
      final companyId = 'company1';
      final error = LocationFailure('Error fetching locations');
      when(() => mockAssetRepository.fetchAssets(companyId))
          .thenAnswer((_) async => DataResult.success([]));
      when(() => mockLocationRepository.fetchLocations(companyId))
          .thenAnswer((_) async => DataResult.failure(error));

      final result = await buildTreeUseCase.fetchTreeData(companyId);

      expect(result.error, isNotNull);
      expect(result.data, isNull);
      expect(result.error!.message, error.message);
    });
  });
  group('BuildTreeIsolated', () {
    test('should build tree correctly with given data', () {
      // Sample data for testing
      final locations = List<Location>.generate(
        10,
        (i) => Location(
          id: 'loc$i',
          name: 'Location $i',
          parentId: i == 0 ? null : 'loc${i - 1}',
        ),
      );

      final assets = List<Asset>.generate(
        10,
        (i) => Asset(
          id: 'asset$i',
          name: 'Asset $i',
          parentId: i == 0 ? null : 'asset${i - 1}',
          locationId: null,
        ),
      );

      final components = List<Component>.generate(
        10,
        (i) => Component(
          id: 'comp$i',
          name: 'Component $i',
          parentId: i == 0 ? null : 'comp${i - 1}',
          locationId: null,
        ),
      );

      final data = {
        'locations': locations,
        'assets': assets,
        'components': components,
      };

      final result = BuildTreeUseCase.buildTreeIsolated(data);

      expect(result, isNotNull);
      expect(result.length, greaterThan(0));

      for (var rootNode in result) {
        verifyTreeStructure(rootNode);
      }
    });
  });
  group('Benchmarks', () {
    test('BuildTreeIsolated Benchmark', () {
      BuildTreeIsolatedBenchmark().report();
    });
  });
}

// Sample data for benchmarking
final deepLocations = List<Location>.generate(
  100000,
  (i) => Location(
    id: 'loc$i',
    name: 'Location $i',
    parentId: i == 0 ? null : 'loc${i - 1}',
  ),
);

final deepAssets = List<Asset>.generate(
  100000,
  (i) => Asset(
    id: 'asset$i',
    name: 'Asset $i',
    parentId: i == 0 ? null : 'asset${i - 1}',
    locationId: null,
  ),
);

final deepComponents = List<Component>.generate(
  100000,
  (i) => Component(
    id: 'comp$i',
    name: 'Component $i',
    parentId: i == 0 ? null : 'comp${i - 1}',
    locationId: null,
  ),
);

final data = {
  'locations': deepLocations,
  'assets': deepAssets,
  'components': deepComponents,
};

class BuildTreeIsolatedBenchmark extends BenchmarkBase {
  BuildTreeIsolatedBenchmark() : super('BuildTreeIsolated');

  @override
  void run() {
    BuildTreeUseCase.buildTreeIsolated(data);
  }
}

/// Helper function to verify the tree structure recursively
void verifyTreeStructure(Node node) {
  if (node.children != null && node.children!.isNotEmpty) {
    expect(node.children!.length, greaterThan(0));
  }

  expect(node.id, isNotNull);
  expect(node.name, isNotNull);
  expect(node.type, isNotNull);

  for (var child in node.children ?? []) {
    verifyTreeStructure(child);
  }
}
