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
  });
}
