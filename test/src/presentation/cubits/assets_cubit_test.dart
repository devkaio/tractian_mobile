import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tractian_mobile/src/core/data_result/data_result.dart';
import 'package:tractian_mobile/src/domain/entities/node.dart';
import 'package:tractian_mobile/src/domain/failures/failure_messages.dart';
import 'package:tractian_mobile/src/domain/failures/repository_failures.dart';
import 'package:tractian_mobile/src/presentation/cubits/assets_cubit.dart';

import '../../domain/domain_mocks.dart';

void main() {
  late AssetCubit assetCubit;
  late MockBuildTreeUseCase mockBuildTreeUseCase;

  final locationNode =
      Node(id: '1', name: 'Location Node', type: NodeType.location);
  final assetNode = Node(id: '2', name: 'Asset Node', type: NodeType.asset);
  final componentNode =
      Node(id: '3', name: 'Component Node', type: NodeType.component);

  setUp(() {
    mockBuildTreeUseCase = MockBuildTreeUseCase();
    assetCubit = AssetCubit(mockBuildTreeUseCase);
  });

  tearDown(() {
    assetCubit.close();
  });

  group('AssetCubit', () {
    blocTest<AssetCubit, AssetState>(
      'emits [loading, success] when fetchAssetTree is called and data is fetched successfully',
      build: () {
        when(() => mockBuildTreeUseCase.fetchTreeData(any())).thenAnswer(
            (_) async =>
                DataResult.success([locationNode, assetNode, componentNode]));
        return assetCubit;
      },
      act: (cubit) => cubit.fetchAssetTree('company1'),
      expect: () => [
        AssetState(status: AssetStateStatus.loading),
        AssetState(
          nodes: [locationNode, assetNode, componentNode],
          status: AssetStateStatus.success,
        ),
      ],
    );

    blocTest<AssetCubit, AssetState>(
      'emits [loading, error] when fetchAssetTree is called and an error occurs',
      build: () {
        when(() => mockBuildTreeUseCase.fetchTreeData(any()))
            .thenAnswer((_) async => DataResult.failure(LocationFailure()));
        return assetCubit;
      },
      act: (cubit) => cubit.fetchAssetTree('company1'),
      expect: () => [
        AssetState(status: AssetStateStatus.loading),
        AssetState(
          status: AssetStateStatus.error,
          message: FAILURE.LOCATION.message,
        ),
      ],
    );

    blocTest<AssetCubit, AssetState>(
      'emits [filtered] when filterByText is called with a non-empty query',
      build: () {
        when(() => mockBuildTreeUseCase.filterTreeData(
                nodes: any(named: 'nodes'), query: any(named: 'query')))
            .thenReturn(
                [Node(id: '4', name: 'Filtered Node', type: NodeType.asset)]);
        return assetCubit;
      },
      seed: () => AssetState(nodes: [locationNode, assetNode, componentNode]),
      act: (cubit) => cubit.filterByText(query: 'Filtered'),
      expect: () => [
        AssetState(
          nodes: [locationNode, assetNode, componentNode],
          filteredNodes: [
            Node(id: '4', name: 'Filtered Node', type: NodeType.asset)
          ],
          status: AssetStateStatus.filtered,
          activeFilter: ActiveFilter.text,
        ),
      ],
    );

    blocTest<AssetCubit, AssetState>(
      'emits [filtered, success] when onFilterByEnergySensorTapped is called',
      build: () {
        when(() =>
            mockBuildTreeUseCase.filterByStatus(
                nodes: any(named: 'nodes'), status: 'operating')).thenReturn(
            [Node(id: '5', name: 'Energy Sensor Node', type: NodeType.asset)]);
        return assetCubit;
      },
      seed: () => AssetState(nodes: [locationNode, assetNode, componentNode]),
      act: (cubit) => cubit.onFilterByEnergySensorTapped(),
      expect: () => [
        AssetState(
          nodes: [locationNode, assetNode, componentNode],
          filteredNodes: [
            Node(id: '5', name: 'Energy Sensor Node', type: NodeType.asset)
          ],
          status: AssetStateStatus.filtered,
          activeFilter: ActiveFilter.energySensor,
        ),
      ],
    );

    blocTest<AssetCubit, AssetState>(
      'emits [filtered, success] when onFilterByCriticStateTapped is called',
      build: () {
        when(() =>
            mockBuildTreeUseCase.filterByStatus(
                nodes: any(named: 'nodes'), status: 'alert')).thenReturn(
            [Node(id: '6', name: 'Critic State Node', type: NodeType.asset)]);
        return assetCubit;
      },
      seed: () => AssetState(nodes: [locationNode, assetNode, componentNode]),
      act: (cubit) => cubit.onFilterByCriticStateTapped(),
      expect: () => [
        AssetState(
          nodes: [locationNode, assetNode, componentNode],
          filteredNodes: [
            Node(id: '6', name: 'Critic State Node', type: NodeType.asset)
          ],
          status: AssetStateStatus.filtered,
          activeFilter: ActiveFilter.criticState,
        ),
      ],
    );
  });
}
