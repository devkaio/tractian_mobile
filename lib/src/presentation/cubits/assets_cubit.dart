import 'package:async/async.dart';
import 'package:data_result/data_result.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  filtered,
  error;
}

class AssetState extends Equatable {
  const AssetState({
    this.nodes = const [],
    this.filteredNodes = const [],
    this.status = AssetStateStatus.initial,
    this.activeFilter = ActiveFilter.none,
    this.message = '',
    this.expandedNodeIds = const {},
  });

  final List<Node> nodes;
  final List<Node> filteredNodes;
  final AssetStateStatus status;
  final ActiveFilter activeFilter;
  final String message;
  final Set<String> expandedNodeIds;

  AssetState copyWith({
    List<Node>? nodes,
    List<Node>? filteredNodes,
    ActiveFilter? activeFilter,
    AssetStateStatus? status,
    String? message,
    Set<String>? expandedNodeIds,
  }) {
    return AssetState(
      nodes: nodes ?? this.nodes,
      filteredNodes: filteredNodes ?? this.filteredNodes,
      activeFilter: activeFilter ?? this.activeFilter,
      status: status ?? this.status,
      message: message ?? this.message,
      expandedNodeIds: expandedNodeIds ?? this.expandedNodeIds,
    );
  }

  @override
  List<Object?> get props => [
        nodes,
        filteredNodes,
        status,
        activeFilter,
        message,
        expandedNodeIds,
      ];

  @override
  bool? get stringify => true;
}

class AssetCubit extends Cubit<AssetState> {
  final BuildTreeUseCase buildTreeUseCase;
  CancelableOperation<DataResult<List<Node>>>? _fetchTreeDataOperation;

  AssetCubit(this.buildTreeUseCase) : super(const AssetState());

  void onExpandedToggled({required String nodeId, required bool isExpanded}) {
    final expandedNodeIds = Set.of(state.expandedNodeIds);

    if (isExpanded) {
      expandedNodeIds.add(nodeId);
    } else {
      expandedNodeIds.remove(nodeId);
    }

    emit(state.copyWith(expandedNodeIds: expandedNodeIds));
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

    final result = await _fetchTreeDataOperation!.valueOrCancellation();

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

  Future<void> filterByText({String query = ''}) async {
    if (query.isEmpty) {
      return emit(
        state.copyWith(
          filteredNodes: [],
          status: AssetStateStatus.success,
          activeFilter: ActiveFilter.none,
        ),
      );
    }

    final filteredNodes = buildTreeUseCase.filterTreeData(
      nodes: state.nodes,
      query: query,
    );

    emit(
      state.copyWith(
        filteredNodes: filteredNodes,
        status: AssetStateStatus.filtered,
        activeFilter: ActiveFilter.text,
      ),
    );
  }

  Future<void> onFilterByEnergySensorTapped() async {
    if (state.activeFilter == ActiveFilter.none ||
        state.activeFilter == ActiveFilter.criticState) {
      final filteredNodes = buildTreeUseCase.filterByStatus(
        nodes: state.nodes,
        status: 'operating',
      );

      return emit(
        state.copyWith(
          filteredNodes: filteredNodes,
          status: AssetStateStatus.filtered,
          activeFilter: ActiveFilter.energySensor,
        ),
      );
    } else {
      emit(
        state.copyWith(
          filteredNodes: [],
          status: AssetStateStatus.success,
          activeFilter: ActiveFilter.none,
        ),
      );
    }
  }

  Future<void> onFilterByCriticStateTapped() async {
    if (state.activeFilter == ActiveFilter.none ||
        state.activeFilter == ActiveFilter.energySensor) {
      final filteredNodes = buildTreeUseCase.filterByStatus(
        nodes: state.nodes,
        status: 'alert',
      );

      return emit(
        state.copyWith(
          filteredNodes: filteredNodes,
          status: AssetStateStatus.filtered,
          activeFilter: ActiveFilter.criticState,
        ),
      );
    } else {
      emit(
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
    return super.close();
  }
}
