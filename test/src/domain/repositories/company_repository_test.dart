import 'package:data_result/data_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tractian_mobile/src/domain/entities/company.dart';
import 'package:tractian_mobile/src/domain/failures/repository_failures.dart';
import 'package:tractian_mobile/src/domain/repositories/company_repository.dart';

void main() {
  group('CompanyRepository', () {
    late MockCompanyRepository mockCompanyRepository;

    setUp(() {
      mockCompanyRepository = MockCompanyRepository();
    });

    test('should return a list of companies on success', () async {
      final companies = [
        Company(
          id: '1',
          name: 'Tractian',
        ),
      ];

      when(() => mockCompanyRepository.getCompanies())
          .thenAnswer((_) async => DataResult.success(companies));

      final result = await mockCompanyRepository.getCompanies();

      expect(result.data, isNotNull);
      expect(result.error, isNull);
      expect(result.data, isA<List<Company>>());
      expect(result.data, companies);
      expect(result.data!.length, 1);
      expect(result.data!.first.name, 'Tractian');
    });

    test('should return failure when API call fails', () async {
      when(() => mockCompanyRepository.getCompanies())
          .thenAnswer((_) async => DataResult.failure(const CompanyFailure()));

      final result = await mockCompanyRepository.getCompanies();

      expect(result.error, isNotNull);
      expect(result.data, isNull);
      expect(result.error, isA<CompanyFailure>());
      expect(result.error, const CompanyFailure());
    });
  });
}

class MockCompanyRepository extends Mock implements CompanyRepository {}
