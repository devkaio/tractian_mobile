import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tractian_mobile/src/domain/entities/asset.dart';
import 'package:tractian_mobile/src/domain/entities/location.dart';
import 'package:tractian_mobile/src/domain/usecases/asset_tree_usecase.dart';

abstract class AssetState {
  const AssetState();
}

class AssetStateInitial extends AssetState {
  const AssetStateInitial();
}

class AssetStateLoading extends AssetState {
  const AssetStateLoading();
}

class AssetStateError extends AssetState {
  final String message;

  const AssetStateError(this.message);
}

class AssetStateSuccess extends AssetState {
  final List<Asset> assets;
  final List<Location> locations;

  const AssetStateSuccess({
    required this.assets,
    required this.locations,
  });
}

class AssetCubit extends Cubit<AssetState> {
  final AssetTreeUseCase assetTreeUseCase;

  AssetCubit(this.assetTreeUseCase) : super(AssetStateInitial());

  Future<void> fetchAssetTree(String companyId) async {
    emit(AssetStateLoading());

    final result = await assetTreeUseCase.fetchAssetTreeData(companyId);

    result.fold(
      (error) => emit(AssetStateError(error.message)),
      (data) {
        final treeData = result.data!;
        final assets = treeData['assets'] as List<Asset>;
        final locations = treeData['locations'] as List<Location>;

        emit(AssetStateSuccess(
          assets: assets,
          locations: locations,
        ));
      },
    );
  }
}
