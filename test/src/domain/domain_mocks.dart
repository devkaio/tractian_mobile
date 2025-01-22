import 'package:mocktail/mocktail.dart';
import 'package:tractian_mobile/src/domain/repositories/asset_repository.dart';
import 'package:tractian_mobile/src/domain/repositories/company_repository.dart';
import 'package:tractian_mobile/src/domain/repositories/location_repository.dart';
import 'package:tractian_mobile/src/domain/usecases/build_tree_usecase.dart';

class MockAssetRepository extends Mock implements AssetRepository {}

class MockCompanyRepository extends Mock implements CompanyRepository {}

class MockLocationRepository extends Mock implements LocationRepository {}

class MockBuildTreeUseCase extends Mock implements BuildTreeUseCase {}
