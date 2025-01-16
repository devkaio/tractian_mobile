import 'package:data_result/data_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tractian_mobile/src/domain/entities/location.dart';
import 'package:tractian_mobile/src/domain/failures/repository_failures.dart';
import 'package:tractian_mobile/src/domain/repositories/location_repository.dart';

void main() {
  group('LocationRepository', () {
    late MockLocationRepository mockLocationRepository;

    setUp(() {
      mockLocationRepository = MockLocationRepository();
    });

    test('should return a list of locations on success', () async {
      final locations = [
        Location(
            id: '1', name: 'PRODUCTION AREA - RAW MATERIAL', parentId: null),
      ];

      when(() => mockLocationRepository.fetchLocations('company1'))
          .thenAnswer((_) async => DataResult.success(locations));

      final result = await mockLocationRepository.fetchLocations('company1');

      expect(result.data, isNotNull);
      expect(result.error, isNull);
      expect(result.data, isA<List<Location>>());
      expect(result.data, locations);
      expect(result.data!.length, 1);
      expect(result.data!.first.name, 'PRODUCTION AREA - RAW MATERIAL');
    });

    test('should return failure when API call fails', () async {
      when(() => mockLocationRepository.fetchLocations('company1'))
          .thenAnswer((_) async => DataResult.failure(const LocationFailure()));

      final result = await mockLocationRepository.fetchLocations('company1');

      expect(result.error, isNotNull);
      expect(result.data, isNull);
      expect(result.error, isA<LocationFailure>());
      expect(result.error, const LocationFailure());
    });
  });
}

class MockLocationRepository extends Mock implements LocationRepository {}
