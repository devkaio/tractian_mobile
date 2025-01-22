import 'package:dio/dio.dart';
import 'package:tractian_mobile/src/core/data_result/data_result.dart';
import 'package:tractian_mobile/src/data/api/dio_client.dart';
import 'package:tractian_mobile/src/domain/entities/company.dart';
import 'package:tractian_mobile/src/domain/failures/repository_failures.dart';
import 'package:tractian_mobile/src/domain/repositories/company_repository.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final DioClient dioClient;

  CompanyRepositoryImpl(this.dioClient);

  @override
  Future<DataResult<List<Company>>> getCompanies() async {
    try {
      final response = await dioClient.get('/companies');
      final companies =
          (response.data as List).map((json) => Company.fromMap(json)).toList();
      return DataResult.success(companies);
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
      return DataResult.failure(const CompanyFailure());
    }
  }
}
