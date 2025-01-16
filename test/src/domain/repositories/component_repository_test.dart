import 'package:data_result/data_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tractian_mobile/src/domain/entities/component.dart';
import 'package:tractian_mobile/src/domain/failures/repository_failures.dart';
import 'package:tractian_mobile/src/domain/repositories/component_repository.dart';

void main() {
  group('ComponentRepository', () {
    late MockComponentRepository mockComponentRepository;

    setUp(() {
      mockComponentRepository = MockComponentRepository();
    });

    test('should return a list of components on success', () async {
      final components = [
        Component(
          id: '1',
          name: 'MOTOR RT COAL AF01',
          sensorType: 'vibration',
          sensorId: 'FIJ309',
          status: 'operating',
          parentId: '2',
        ),
      ];

      when(() => mockComponentRepository.fetchComponents('company1'))
          .thenAnswer((_) async => DataResult.success(components));

      final result = await mockComponentRepository.fetchComponents('company1');

      expect(result.data, isNotNull);
      expect(result.error, isNull);
      expect(result.data, isA<List<Component>>());
      expect(result.data, components);
      expect(result.data!.length, 1);
      expect(result.data!.first.name, 'MOTOR RT COAL AF01');
    });

    test('should return failure when API call fails', () async {
      when(() => mockComponentRepository.fetchComponents('company1'))
          .thenAnswer(
              (_) async => DataResult.failure(const ComponentFailure()));

      final result = await mockComponentRepository.fetchComponents('company1');

      expect(result.error, isNotNull);
      expect(result.data, isNull);
      expect(result.error, isA<ComponentFailure>());
      expect(result.error, const ComponentFailure());
    });
  });
}

class MockComponentRepository extends Mock implements ComponentRepository {}
