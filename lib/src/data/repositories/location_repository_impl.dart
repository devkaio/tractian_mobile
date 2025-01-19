import 'package:data_result/data_result.dart';
import 'package:dio/dio.dart';
import 'package:tractian_mobile/src/data/api/dio_client.dart';
import 'package:tractian_mobile/src/domain/entities/location.dart';
import 'package:tractian_mobile/src/domain/failures/repository_failures.dart';
import 'package:tractian_mobile/src/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final DioClient dioClient;

  LocationRepositoryImpl(this.dioClient);

  @override
  Future<DataResult<List<Location>>> fetchLocations(String companyId) async {
    try {
      final response = await dioClient.get('/companies/$companyId/locations');
      final locations = (response.data as List)
          .map((json) => Location.fromMap(json))
          .toList();
      return DataResult.success(locations);
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
      return DataResult.failure(const LocationFailure());
    }
  }
}
