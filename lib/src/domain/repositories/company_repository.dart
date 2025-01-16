import 'package:data_result/data_result.dart';
import 'package:tractian_mobile/src/domain/entities/company.dart';

abstract class CompanyRepository {
  Future<DataResult<List<Company>>> getCompanies();
}
