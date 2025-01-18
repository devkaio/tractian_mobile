import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tractian_mobile/src/domain/entities/node.dart';
import 'package:tractian_mobile/src/domain/usecases/build_tree_usecase.dart';

enum AssetStateStatus {
  initial,
  loading,
  success,
  filtered,
  error;
}

class AssetState {
  const AssetState({
    this.nodes = const [],
    this.filteredNodes = const [],
    this.status = AssetStateStatus.initial,
    this.message = '',
  });

  final List<Node> nodes;
  final List<Node> filteredNodes;
  final AssetStateStatus status;
  final String message;

  AssetState copyWith({
    List<Node>? nodes,
    List<Node>? filteredNodes,
    AssetStateStatus? status,
    String? message,
  }) {
    return AssetState(
      nodes: nodes ?? this.nodes,
      filteredNodes: filteredNodes ?? this.filteredNodes,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}

class AssetCubit extends Cubit<AssetState> {
  final BuildTreeUseCase buildTreeUseCase;

  AssetCubit(this.buildTreeUseCase) : super(const AssetState());

  Future<void> fetchAssetTree(String companyId) async {
    emit(state.copyWith(status: AssetStateStatus.loading));

    final result = await buildTreeUseCase.fetchTreeData(companyId);

    result.fold(
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
          filteredNodes: state.nodes,
          status: AssetStateStatus.filtered,
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
      ),
    );
  }
}
