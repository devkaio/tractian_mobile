import 'package:data_result/data_result.dart';
import 'package:tractian_mobile/src/domain/entities/location.dart';

abstract class LocationRepository {
  Future<DataResult<List<Location>>> fetchLocations(String companyId);
}
