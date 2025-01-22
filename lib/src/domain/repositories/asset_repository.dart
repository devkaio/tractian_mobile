import 'package:tractian_mobile/src/core/data_result/data_result.dart';
import 'package:tractian_mobile/src/domain/entities/asset.dart';

abstract class AssetRepository {
  Future<DataResult<List<Asset>>> fetchAssets(String companyId);
}
