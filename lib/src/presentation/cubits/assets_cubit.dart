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
    this.textQuery = ''
  });

  final List<Node> nodes;
  final List<Node> filteredNodes;
  final AssetStateStatus status;
  final ActiveFilter activeFilter;
  final String message;
  final String textQuery;

  AssetState copyWith({
    List<Node>? nodes,
    List<Node>? filteredNodes,
    ActiveFilter? activeFilter,
    AssetStateStatus? status,
    String? message,
    String? textQuery,
  }) {
    return AssetState(
      nodes: nodes ?? this.nodes,
      filteredNodes: filteredNodes ?? this.filteredNodes,
      activeFilter: activeFilter ?? this.activeFilter,
      status: status ?? this.status,
      message: message ?? this.message,
      textQuery: textQuery ?? this.textQuery,
    );
  }

  @override
  List<Object?> get props => [
        nodes,
        filteredNodes,
        status,
        activeFilter,
        message,
        textQuery,
      ];

  @override
  bool? get stringify => true;
}

class AssetCubit extends Cubit<AssetState> {
  final BuildTreeUseCase buildTreeUseCase;
  CancelableOperation<DataResult<List<Node>>>? _fetchTreeDataOperation;
  CancelableOperation<List<Node>>? _filterOperation;

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
    _debounceTimer = Timer(const Duration(milliseconds: 500), () => _applyFilters(query: query));
  }

  Future<void> onFilterByEnergySensorTapped() async {
    final isActive = state.activeFilter == ActiveFilter.energySensor;
    await _applyFilters(activeFilter: isActive ? ActiveFilter.none : ActiveFilter.energySensor);
  }

  Future<void> onFilterByCriticStateTapped() async {
    final isActive = state.activeFilter == ActiveFilter.criticState;
    await _applyFilters(activeFilter: isActive ? ActiveFilter.none : ActiveFilter.criticState);
  }
  
  Future<void> _applyFilters({
    String? query,
    ActiveFilter? activeFilter,
  }) async {
    emit(state.copyWith(status: AssetStateStatus.loading));

    _filterOperation?.cancel();

    final filter = activeFilter ?? state.activeFilter;
    final text = query ?? state.textQuery;

    NodeSensorType? sensorType;
    NodeStatus? status;

    if (filter == ActiveFilter.energySensor) {
      sensorType = NodeSensorType.energy;
    } else if (filter == ActiveFilter.criticState) {
      status = NodeStatus.alert;
    }

    final filteredNodes = await buildTreeUseCase.filterTreeData(
      nodes: state.nodes,
      query: text.isNotEmpty ? text : null,
      sensorType: sensorType,
      status: status,
    );

    final bool isTextOnly = (filter == ActiveFilter.none) && text.isNotEmpty;

    emit(state.copyWith(
      filteredNodes: filteredNodes,
      status: AssetStateStatus.success,
      activeFilter: isTextOnly ? ActiveFilter.text : filter,
      textQuery: text,
    ));
  }

  @override
  Future<void> close() {
    _fetchTreeDataOperation?.cancel();
    _filterOperation?.cancel();
    return super.close();
  }
}
