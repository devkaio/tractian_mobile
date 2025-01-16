import 'package:data_result/data_result.dart';
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
          .map((json) => Location.fromJson(json))
          .toList();
      return DataResult.success(locations);
    } catch (e) {
      return DataResult.failure(LocationFailure());
    }
  }
}
