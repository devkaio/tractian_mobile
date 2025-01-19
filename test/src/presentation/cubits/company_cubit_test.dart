import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tractian_mobile/src/core/data_result/data_result.dart';
import 'package:tractian_mobile/src/domain/entities/company.dart';
import 'package:tractian_mobile/src/domain/failures/failure_messages.dart';
import 'package:tractian_mobile/src/domain/failures/repository_failures.dart';
import 'package:tractian_mobile/src/domain/repositories/company_repository.dart';
import 'package:tractian_mobile/src/presentation/cubits/company_cubit.dart';

class MockCompanyRepository extends Mock implements CompanyRepository {}

void main() {
  late CompanyCubit companyCubit;
  late MockCompanyRepository mockCompanyRepository;

  setUp(() {
    mockCompanyRepository = MockCompanyRepository();
    companyCubit = CompanyCubit(mockCompanyRepository);
  });

  tearDown(() {
    companyCubit.close();
  });

  group('CompanyCubit', () {
    blocTest<CompanyCubit, CompanyState>(
      'emits [loading, success] when fetchCompanies is called and data is fetched successfully',
      build: () {
        when(() => mockCompanyRepository.getCompanies()).thenAnswer((_) async =>
            DataResult.success([Company(id: '1', name: 'Company 1')]));
        return companyCubit;
      },
      act: (cubit) => cubit.fetchCompanies(),
      expect: () => [
        CompanyState(status: CompanyStateStatus.loading),
        CompanyState(
          status: CompanyStateStatus.success,
          companies: [Company(id: '1', name: 'Company 1')],
        ),
      ],
    );

    blocTest<CompanyCubit, CompanyState>(
      'emits [loading, error] when fetchCompanies is called and an error occurs',
      build: () {
        when(() => mockCompanyRepository.getCompanies())
            .thenAnswer((_) async => DataResult.failure(CompanyFailure()));
        return companyCubit;
      },
      act: (cubit) => cubit.fetchCompanies(),
      expect: () => [
        CompanyState(status: CompanyStateStatus.loading),
        CompanyState(
          status: CompanyStateStatus.error,
          message: FAILURE.COMPANY.message,
        ),
      ],
    );
  });
}
