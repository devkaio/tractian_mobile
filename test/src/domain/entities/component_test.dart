import 'package:flutter_test/flutter_test.dart';
import 'package:tractian_mobile/src/domain/entities/component.dart';

void main() {
  group('Component', () {
    test('should create a Component correctly', () {
      final component = Component(
        id: '1',
        name: 'MOTOR RT COAL AF01',
        sensorType: 'vibration',
        sensorId: 'FIJ309',
        status: 'operating',
        parentId: '2',
      );

      expect(component.id, '1');
      expect(component.name, 'MOTOR RT COAL AF01');
      expect(component.sensorType, 'vibration');
      expect(component.status, 'operating');
      expect(component.parentId, '2');
    });
  });
}
