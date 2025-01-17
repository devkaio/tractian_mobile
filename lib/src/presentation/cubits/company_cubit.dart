import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tractian_mobile/src/domain/entities/company.dart';
import 'package:tractian_mobile/src/domain/repositories/company_repository.dart';

class CompanyCubit extends Cubit<CompanyState> {
  final CompanyRepository _companyRepository;

  CompanyCubit(this._companyRepository) : super(const CompanyStateInitial());

  Future<void> fetchCompanies() async {
    emit(CompanyStateLoading());
    final result = await _companyRepository.getCompanies();
    result.fold(
      (error) => emit(CompanyStateError(error.message)),
      (data) => emit(CompanyStateSuccess(data)),
    );
  }
}

abstract class CompanyState {
  const CompanyState();
}

class CompanyStateInitial extends CompanyState {
  const CompanyStateInitial();
}

class CompanyStateLoading extends CompanyState {
  const CompanyStateLoading();
}

class CompanyStateError extends CompanyState {
  final String message;

  const CompanyStateError(this.message);
}

class CompanyStateSuccess extends CompanyState {
  final List<Company> result;

  const CompanyStateSuccess(this.result);
}
