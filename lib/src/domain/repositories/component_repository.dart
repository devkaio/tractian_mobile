import 'package:data_result/data_result.dart';
import 'package:tractian_mobile/src/domain/entities/component.dart';

abstract class ComponentRepository {
  Future<DataResult<List<Component>>> fetchComponents(String companyId);
}
