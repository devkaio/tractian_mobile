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
        status: 'operating',
      );

      expect(asset.id, '1');
      expect(asset.name, 'Fan - External');
      expect(asset.locationId, null);
      expect(asset.sensorType, 'energy');
      expect(asset.status, 'operating');
    });

    test('should convert Asset to map correctly', () {
      final asset = Asset(
        id: '1',
        name: 'Fan - External',
        locationId: 'loc1',
        parentId: 'parent1',
        sensorType: 'energy',
        status: 'operating',
      );

      final assetMap = asset.toMap();

      expect(assetMap, {
        'id': '1',
        'name': 'Fan - External',
        'locationId': 'loc1',
        'parentId': 'parent1',
        'sensorType': 'energy',
        'status': 'operating',
      });
    });

    test('should create Asset from map correctly', () {
      final assetMap = {
        'id': '1',
        'name': 'Fan - External',
        'locationId': 'loc1',
        'parentId': 'parent1',
        'sensorType': 'energy',
        'status': 'operating',
      };

      final asset = Asset.fromMap(assetMap);

      expect(asset.id, '1');
      expect(asset.name, 'Fan - External');
      expect(asset.locationId, 'loc1');
      expect(asset.parentId, 'parent1');
      expect(asset.sensorType, 'energy');
      expect(asset.status, 'operating');
    });

    test('should convert Asset to JSON correctly', () {
      final asset = Asset(
        id: '1',
        name: 'Fan - External',
        locationId: 'loc1',
        parentId: 'parent1',
        sensorType: 'energy',
        status: 'operating',
      );

      final assetJson = asset.toJson();

      expect(assetJson,
          '{"id":"1","name":"Fan - External","locationId":"loc1","parentId":"parent1","sensorType":"energy","status":"operating"}');
    });

    test('should create Asset from JSON correctly', () {
      final assetJson =
          '{"id":"1","name":"Fan - External","locationId":"loc1","parentId":"parent1","sensorType":"energy","status":"operating"}';

      final asset = Asset.fromJson(assetJson);

      expect(asset.id, '1');
      expect(asset.name, 'Fan - External');
      expect(asset.locationId, 'loc1');
      expect(asset.parentId, 'parent1');
      expect(asset.sensorType, 'energy');
      expect(asset.status, 'operating');
    });
  });
}
