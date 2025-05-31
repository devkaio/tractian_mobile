import 'dart:async';

import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tractian_mobile/src/core/data_result/data_result.dart';
import 'package:tractian_mobile/src/domain/entities/node.dart';
import 'package:tractian_mobile/src/domain/usecases/build_tree_usecase.dart';

enum ActiveFilter {
  none,
  energySensor,
  criticState,
  text,
}

enum AssetStateStatus {
  initial,
  loading,
  success,
  error;
}

class AssetState extends Equatable {
  const AssetState({
    this.nodes = const [],
    this.filteredNodes = const [],
    this.status = AssetStateStatus.initial,
    this.activeFilter = ActiveFilter.none,
    this.message = '',
  });

  final List<Node> nodes;
  final List<Node> filteredNodes;
  final AssetStateStatus status;
  final ActiveFilter activeFilter;
  final String message;

  AssetState copyWith({
    List<Node>? nodes,
    List<Node>? filteredNodes,
    ActiveFilter? activeFilter,
    AssetStateStatus? status,
    String? message,
  }) {
    return AssetState(
      nodes: nodes ?? this.nodes,
      filteredNodes: filteredNodes ?? this.filteredNodes,
      activeFilter: activeFilter ?? this.activeFilter,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        nodes,
        filteredNodes,
        status,
        activeFilter,
        message,
      ];

  @override
  bool? get stringify => true;
}

class AssetCubit extends Cubit<AssetState> {
  final BuildTreeUseCase buildTreeUseCase;
  CancelableOperation<DataResult<List<Node>>>? _fetchTreeDataOperation;
  CancelableOperation<List<Node>>? _filterByTextOperation;
  CancelableOperation<List<Node>>? _filterByEnergySensorOperation;
  CancelableOperation<List<Node>>? _filterByCriticStateOperation;

  Timer? _debounceTimer;

  AssetCubit(this.buildTreeUseCase) : super(const AssetState());

  void onExpandedToggled(Node node) {
    final isFiltered = state.activeFilter != ActiveFilter.none;
    final nodes = isFiltered ? state.filteredNodes : state.nodes;

  final updatedNodes = nodes.expandOne(node.id);

    emit(
      state.copyWith(
        nodes: isFiltered ? state.nodes : updatedNodes,
        filteredNodes: isFiltered ? updatedNodes : state.filteredNodes,
      ),
    );
  }

  Future<void> fetchAssetTree(String companyId) async {
    emit(state.copyWith(
      status: AssetStateStatus.loading,
      filteredNodes: [],
      activeFilter: ActiveFilter.none,
    ));

    _fetchTreeDataOperation?.cancel();

    _fetchTreeDataOperation = CancelableOperation.fromFuture(
      buildTreeUseCase.fetchTreeData(companyId),
      onCancel: () {
        return;
      },
    );

    final result = await _fetchTreeDataOperation!
        .valueOrCancellation(DataResult.success([]));

    result?.fold(
      (error) {
        emit(state.copyWith(
          status: AssetStateStatus.error,
          message: error.message,
        ));
      },
      (nodes) {
        emit(
          state.copyWith(
            nodes: nodes,
            status: AssetStateStatus.success,
          ),
        );
      },
    );
  }

  void onTextQuery([String query = '']) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _filterByText(query);
    });
  }

  Future<void> _filterByText([String query = '']) async {
    emit(state.copyWith(status: AssetStateStatus.loading));

    _filterByTextOperation?.cancel();

    _filterByTextOperation = CancelableOperation.fromFuture(
      buildTreeUseCase.filterTreeData(
        nodes: state.nodes,
        query: query,
      ),
      onCancel: () {
        return;
      },
    );

    final filteredNodes = await _filterByTextOperation?.valueOrCancellation([]);

    emit(
      state.copyWith(
        filteredNodes: filteredNodes,
        status: AssetStateStatus.success,
        activeFilter: ActiveFilter.text,
      ),
    );
  }

  Future<void> onFilterByEnergySensorTapped() async {
    emit(state.copyWith(status: AssetStateStatus.loading));

    if (state.activeFilter == ActiveFilter.none ||
        state.activeFilter == ActiveFilter.criticState) {
      _filterByEnergySensorOperation?.cancel();

      _filterByEnergySensorOperation = CancelableOperation.fromFuture(
        buildTreeUseCase.filterTreeData(
          nodes: state.nodes,
          sensorType: NodeSensorType.energy,
        ),
        onCancel: () {
          return;
        },
      );

      final filteredNodes =
          await _filterByEnergySensorOperation?.valueOrCancellation([]);

      return emit(
        state.copyWith(
          filteredNodes: filteredNodes,
          status: AssetStateStatus.success,
          activeFilter: ActiveFilter.energySensor,
        ),
      );
    } else {
      return emit(
        state.copyWith(
          filteredNodes: [],
          status: AssetStateStatus.success,
          activeFilter: ActiveFilter.none,
        ),
      );
    }
  }

  Future<void> onFilterByCriticStateTapped() async {
    emit(state.copyWith(status: AssetStateStatus.loading));

    if (state.activeFilter == ActiveFilter.none ||
        state.activeFilter == ActiveFilter.energySensor) {
      _filterByCriticStateOperation?.cancel();

      _filterByCriticStateOperation = CancelableOperation.fromFuture(
        buildTreeUseCase.filterTreeData(
          nodes: state.nodes,
          status: NodeStatus.alert,
        ),
        onCancel: () {
          return;
        },
      );

      final filteredNodes =
          await _filterByCriticStateOperation?.valueOrCancellation([]);

      return emit(
        state.copyWith(
          filteredNodes: filteredNodes,
          status: AssetStateStatus.success,
          activeFilter: ActiveFilter.criticState,
        ),
      );
    } else {
      return emit(
        state.copyWith(
          filteredNodes: [],
          status: AssetStateStatus.success,
          activeFilter: ActiveFilter.none,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _fetchTreeDataOperation?.cancel();
    _filterByTextOperation?.cancel();
    _filterByEnergySensorOperation?.cancel();
    return super.close();
  }
}
