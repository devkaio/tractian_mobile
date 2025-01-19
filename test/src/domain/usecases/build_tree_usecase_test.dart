import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tractian_mobile/src/domain/entities/asset.dart';
import 'package:tractian_mobile/src/domain/entities/component.dart';
import 'package:tractian_mobile/src/domain/entities/location.dart';
import 'package:tractian_mobile/src/domain/entities/node.dart';
import 'package:tractian_mobile/src/domain/usecases/build_tree_usecase.dart';

void main() {
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

      // Call the static method
      final result = BuildTreeUseCase.buildTreeIsolated(data);

      // Verify the result
      expect(result, isNotNull);
      expect(result.length, greaterThan(0));
      // Verify the structure of the tree
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
