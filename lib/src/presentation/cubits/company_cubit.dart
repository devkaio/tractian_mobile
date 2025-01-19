import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tractian_mobile/src/domain/entities/company.dart';
import 'package:tractian_mobile/src/domain/repositories/company_repository.dart';

class CompanyCubit extends Cubit<CompanyState> {
  final CompanyRepository _companyRepository;

  CompanyCubit(this._companyRepository) : super(const CompanyState());

  Future<void> fetchCompanies() async {
    emit(state.copyWith(status: CompanyStateStatus.loading));
    final result = await _companyRepository.getCompanies();
    result.fold(
      (error) => emit(
        state.copyWith(
          status: CompanyStateStatus.error,
          message: error.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          status: CompanyStateStatus.success,
          companies: data,
        ),
      ),
    );
  }
}

enum CompanyStateStatus {
  initial,
  loading,
  success,
  error,
}

class CompanyState {
  const CompanyState({
    this.status = CompanyStateStatus.initial,
    this.message = '',
    this.companies = const [],
  });

  final CompanyStateStatus status;
  final String message;
  final List<Company> companies;

  CompanyState copyWith({
    CompanyStateStatus? status,
    String? message,
    List<Company>? companies,
  }) {
    return CompanyState(
      status: status ?? this.status,
      message: message ?? this.message,
      companies: companies ?? this.companies,
    );
  }
}
