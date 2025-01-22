import 'package:flutter_test/flutter_test.dart';
import 'package:tractian_mobile/src/domain/entities/location.dart';

void main() {
  group('Location', () {
    test('should create a Location correctly', () {
      final location = Location(
        id: '1',
        name: 'PRODUCTION AREA - RAW MATERIAL',
        parentId: null,
      );

      expect(location.id, '1');
      expect(location.name, 'PRODUCTION AREA - RAW MATERIAL');
      expect(location.parentId, null);
    });

    test('should convert Location to Map correctly', () {
      final location = Location(
        id: '1',
        name: 'PRODUCTION AREA - RAW MATERIAL',
        parentId: null,
      );

      final locationMap = location.toMap();

      expect(locationMap, {
        'id': '1',
        'name': 'PRODUCTION AREA - RAW MATERIAL',
        'parentId': null,
      });
    });

    test('should create a Location from Map correctly', () {
      final locationMap = {
        'id': '1',
        'name': 'PRODUCTION AREA - RAW MATERIAL',
        'parentId': null,
      };

      final location = Location.fromMap(locationMap);

      expect(location.id, '1');
      expect(location.name, 'PRODUCTION AREA - RAW MATERIAL');
      expect(location.parentId, null);
    });

    test('should convert Location to JSON correctly', () {
      final location = Location(
        id: '1',
        name: 'PRODUCTION AREA - RAW MATERIAL',
        parentId: null,
      );

      final locationJson = location.toJson();

      expect(locationJson,
          '{"id":"1","name":"PRODUCTION AREA - RAW MATERIAL","parentId":null}');
    });

    test('should create a Location from JSON correctly', () {
      final locationJson =
          '{"id":"1","name":"PRODUCTION AREA - RAW MATERIAL","parentId":null}';

      final location = Location.fromJson(locationJson);

      expect(location.id, '1');
      expect(location.name, 'PRODUCTION AREA - RAW MATERIAL');
      expect(location.parentId, null);
    });
  });
}
