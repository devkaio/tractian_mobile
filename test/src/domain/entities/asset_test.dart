import 'package:flutter_test/flutter_test.dart';
import 'package:tractian_mobile/src/domain/entities/asset.dart';

void main() {
  group('Asset', () {
    test('should create an Asset correctly', () {
      final asset = Asset(
        id: '1',
        name: 'Fan - External',
        locationId: null,
        parentId: null,
        sensorType: 'energy',
        sensorId: 'MTC052',
        status: 'operating',
      );

      expect(asset.id, '1');
      expect(asset.name, 'Fan - External');
      expect(asset.locationId, null);
      expect(asset.sensorType, 'energy');
      expect(asset.status, 'operating');
    });
  });
}
