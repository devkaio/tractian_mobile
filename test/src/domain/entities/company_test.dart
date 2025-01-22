import 'package:flutter_test/flutter_test.dart';
import 'package:tractian_mobile/src/domain/entities/company.dart';

void main() {
  group('Company', () {
    test('should create a Company correctly', () {
      final company = Company(
        id: '1',
        name: 'Tractian',
      );

      expect(company.id, '1');
      expect(company.name, 'Tractian');
    });

    test('toMap should return a valid map', () {
      final company = Company(
        id: '1',
        name: 'Tractian',
      );

      final map = company.toMap();

      expect(map, {
        'id': '1',
        'name': 'Tractian',
      });
    });

    test('fromMap should return a valid Company object', () {
      final map = {
        'id': '1',
        'name': 'Tractian',
      };

      final company = Company.fromMap(map);

      expect(company.id, '1');
      expect(company.name, 'Tractian');
    });

    test('toJson should return a valid JSON string', () {
      final company = Company(
        id: '1',
        name: 'Tractian',
      );

      final jsonStr = company.toJson();

      expect(jsonStr, '{"id":"1","name":"Tractian"}');
    });

    test('fromJson should return a valid Company object', () {
      final jsonStr = '{"id":"1","name":"Tractian"}';

      final company = Company.fromJson(jsonStr);

      expect(company.id, '1');
      expect(company.name, 'Tractian');
    });
  });
}
