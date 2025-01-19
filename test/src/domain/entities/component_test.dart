import 'package:flutter_test/flutter_test.dart';
import 'package:tractian_mobile/src/domain/entities/component.dart';

void main() {
  group('Component', () {
    const component = Component(
      id: '1',
      name: 'Component 1',
      parentId: '0',
      locationId: 'loc1',
      sensorType: 'type1',
      status: 'active',
    );

    test('props are correct', () {
      expect(
        component.props,
        [
          '1',
          'Component 1',
          '0',
          'loc1',
          'type1',
          'active',
        ],
      );
    });

    test('toMap returns correct map', () {
      expect(
        component.toMap(),
        {
          'id': '1',
          'name': 'Component 1',
          'parentId': '0',
          'locationId': 'loc1',
          'sensorType': 'type1',
          'status': 'active',
        },
      );
    });

    test('fromMap returns correct Component', () {
      final map = {
        'id': '1',
        'name': 'Component 1',
        'parentId': '0',
        'locationId': 'loc1',
        'sensorType': 'type1',
        'status': 'active',
      };
      expect(Component.fromMap(map), component);
    });

    test('toJson returns correct JSON string', () {
      expect(
        component.toJson(),
        '{"id":"1","name":"Component 1","parentId":"0","locationId":"loc1","sensorType":"type1","status":"active"}',
      );
    });

    test('fromJson returns correct Component', () {
      const jsonString =
          '{"id":"1","name":"Component 1","parentId":"0","locationId":"loc1","sensorType":"type1","status":"active"}';
      expect(Component.fromJson(jsonString), component);
    });
  });
}
