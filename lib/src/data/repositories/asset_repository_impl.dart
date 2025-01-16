import 'package:data_result/data_result.dart';
import 'package:tractian_mobile/src/data/api/dio_client.dart';
import 'package:tractian_mobile/src/domain/entities/asset.dart';
import 'package:tractian_mobile/src/domain/failures/repository_failures.dart';
import 'package:tractian_mobile/src/domain/repositories/asset_repository.dart';

class AssetRepositoryImpl implements AssetRepository {
  final DioClient dioClient;

  AssetRepositoryImpl(this.dioClient);

  @override
  Future<DataResult<List<Asset>>> fetchAssets(String companyId) async {
    try {
      final response = await dioClient.get('/companies/$companyId/assets');
      final assets =
          (response.data as List).map((json) => Asset.fromJson(json)).toList();
      return DataResult.success(assets);
    } catch (e) {
      return DataResult.failure(AssetFailure());
    }
  }
}
