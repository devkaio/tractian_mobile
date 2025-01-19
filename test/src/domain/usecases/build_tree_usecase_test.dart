import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tractian_mobile/src/core/data_result/data_result.dart';
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

  group('BuildTreeUseCase Benchmark', () {
    test('Benchmark BuildTreeUseCase', () {
      BuildTreeIsolatedBenchmark().report();
    });
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
      when(() => mockAssetRepository.fetchAssets(companyId)).thenAnswer(
        (_) async => DataResult.failure(error),
      );
      when(() => mockLocationRepository.fetchLocations(companyId)).thenAnswer(
        (_) async => DataResult.success([]),
      );

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
      when(() => mockAssetRepository.fetchAssets(companyId)).thenAnswer(
        (_) async => DataResult.success([]),
      );
      when(() => mockLocationRepository.fetchLocations(companyId)).thenAnswer(
        (_) async => DataResult.failure(error),
      );

      final result = await buildTreeUseCase.fetchTreeData(companyId);

      expect(result.error, isNotNull);
      expect(result.data, isNull);
      expect(result.error!.message, error.message);
    });
  });

  group('BuildTreeIsolated', () {
    test('should build tree correctly with given data', () {
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
          locationId: i % 2 == 0 ? 'loc${i % 5}' : null,
        ),
      );

      final data = {
        'locations': locations,
        'assets': assets,
        'components': components,
      };

      final result = BuildTreeUseCase.buildTree(data);

      expect(result, isNotNull);
      expect(result.length, greaterThan(0));

      for (var rootNode in result) {
        verifyTreeStructure(rootNode);
      }
    });

    test('Components linked to locations are populated as children', () {
      final locations = [
        Location(id: 'loc1', name: 'Location 1', parentId: null),
        Location(id: 'loc2', name: 'Location 2', parentId: null),
      ];

      final components = [
        Component(
          id: 'comp1',
          name: 'Component 1',
          parentId: null,
          locationId: 'loc1',
          sensorType: 'sensor1',
          status: 'active',
        ),
        Component(
          id: 'comp2',
          name: 'Component 2',
          parentId: null,
          locationId: 'loc2',
          sensorType: 'sensor2',
          status: 'active',
        ),
      ];

      final data = {
        'locations': locations,
        'assets': <Asset>[],
        'components': components,
      };

      final result = BuildTreeUseCase.buildTree(data);

      expect(result, isNotNull);
      for (var node in result) {
        if (node.type == NodeType.location) {
          expect(node.children, isNotNull);
          expect(node.children.length, greaterThan(0));
          for (var child in node.children) {
            expect(child.type, NodeType.component);
          }
        }
      }
    });

    test(
        'Component linked at the root and as the child of a location at the third level of depth',
        () {
      final locations = createTreeWithDepth(3);

      final components = [
        Component(
          id: 'comp1',
          name: 'Component 1',
          parentId: null,
          locationId: 'loc3', // Third level location
          sensorType: 'sensor1',
          status: 'active',
        ),
      ];

      final data = {
        'locations': locations,
        'assets': <Asset>[],
        'components': components,
      };

      final result = BuildTreeUseCase.buildTree(data);

      expect(result, isNotNull);
      for (var node in result) {
        if (node.type == NodeType.location) {
          if (node.id == 'loc3') {
            expect(node.children, isNotNull);
            expect(node.children.length, greaterThan(0));
            for (var child in node.children) {
              expect(child.type, NodeType.component);
            }
          }
        }
      }
    });
  });
}

// Sample data for benchmarking
final deepLocations = List<Location>.generate(
  10000,
  (i) => Location(
    id: 'loc$i',
    name: 'Location $i',
    parentId: i == 0 ? null : 'loc${i - 1}',
  ),
);

final deepAssets = List<Asset>.generate(
  10000,
  (i) => Asset(
    id: 'asset$i',
    name: 'Asset $i',
    parentId: i == 0 ? null : 'asset${i - 1}',
    locationId: null,
  ),
);

final deepComponents = List<Component>.generate(
  10000,
  (i) => Component(
    id: 'comp$i',
    name: 'Component $i',
    parentId: i == 0 ? null : 'comp${i - 1}',
    sensorType: i % 25 == 0
        ? 'energy'
        : i % 20 == 0
            ? 'temperature'
            : null,
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
    BuildTreeUseCase.buildTree(data);
  }
}

/// Helper function to verify the tree structure recursively
void verifyTreeStructure(Node node) {
  if (node.children.isNotEmpty) {
    expect(node.children.length, greaterThan(0));
  }

  expect(node.id, isNotNull);
  expect(node.name, isNotNull);
  expect(node.type, isNotNull);

  for (var child in node.children) {
    verifyTreeStructure(child);
  }
}

/// Helper function to create a tree with a given depth
List<Location> createTreeWithDepth(int depth) {
  final locations = <Location>[];
  String? parentId;

  for (int i = 1; i <= depth; i++) {
    final location = Location(
      id: 'loc$i',
      name: 'Location $i',
      parentId: parentId,
    );
    locations.add(location);
    parentId = location.id;
  }

  return locations;
}

/// Helper function to find a component in a tree with a given depth
bool findComponentInTree(
    Node node, String componentId, int currentDepth, int targetDepth) {
  if (currentDepth == targetDepth) {
    return node.children.any(
      (child) => child.type == NodeType.component && child.id == componentId,
    );
  }

  return node.children.any((child) =>
      child.type == NodeType.location &&
      findComponentInTree(
        child,
        componentId,
        currentDepth + 1,
        targetDepth,
      ));
}
