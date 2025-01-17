import 'package:data_result/data_result.dart';
import 'package:tractian_mobile/src/domain/repositories/asset_repository.dart';
import 'package:tractian_mobile/src/domain/repositories/location_repository.dart';

class AssetTreeUseCase {
  final AssetRepository assetRepository;
  final LocationRepository locationRepository;

  AssetTreeUseCase({
    required this.assetRepository,
    required this.locationRepository,
  });

  Future<DataResult<Map<String, dynamic>>> fetchAssetTreeData(
      String companyId) async {
    final assetResult = await assetRepository.fetchAssets(companyId);
    final locationResult = await locationRepository.fetchLocations(companyId);

    if (assetResult.error != null) {
      return DataResult.failure(assetResult.error!);
    }

    if (locationResult.error != null) {
      return DataResult.failure(locationResult.error!);
    }

    final assets = assetResult.data!;
    final locations = locationResult.data!;

    return DataResult.success({
      'assets': assets,
      'locations': locations,
    });
  }
}
