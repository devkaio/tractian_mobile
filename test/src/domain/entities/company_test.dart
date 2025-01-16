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
  });
}
