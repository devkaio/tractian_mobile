import 'package:dio/dio.dart';
import 'package:tractian_mobile/src/core/data_result/data_result.dart';
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
          (response.data as List).map((json) => Asset.fromMap(json)).toList();
      return DataResult.success(assets);
    } on DioException catch (e) {
      if ([
        DioExceptionType.connectionError,
        DioExceptionType.sendTimeout,
        DioExceptionType.connectionTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.cancel,
      ].contains(e.type)) {
        return DataResult.failure(const NetworkException());
      }
      return DataResult.failure(const UnknownFailure());
    } catch (e) {
      return DataResult.failure(const AssetFailure());
    }
  }
}
