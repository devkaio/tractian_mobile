import 'package:data_result/data_result.dart';
import 'package:flutter_test/flutter_test.dart';

class MockFailure implements Failure {
  const MockFailure(this._message);

  final String _message;

  @override
  String get message => _message;
}

void main() {
  group('DataResult Tests', () {
    test('should return data for success case', () {
      const data = 'Test Data';
      final result = DataResult.success(data);

      final dataResult = result.data;

      expect(dataResult, equals(data));
    });

    test('should return null error for success case', () {
      const data = 'Test Data';
      final result = DataResult.success(data);

      final errorResult = result.error;

      expect(errorResult, isNull);
    });

    test('should return error for failure case', () {
      const failure = MockFailure('Something went wrong');
      final result = DataResult.failure(failure);

      final errorResult = result.error;

      expect(errorResult?.message, equals('Something went wrong'));
    });

    test('should return null data for failure case', () {
      const failure = MockFailure('Something went wrong');
      final result = DataResult.failure(failure);

      final dataResult = result.data;

      expect(dataResult, isNull);
    });

    test('should correctly fold over data for success case', () {
      const data = 'Test Data';
      final result = DataResult.success(data);

      final foldResult = result.fold(
        (failure) => 'Failure',
        (data) => 'Success: $data',
      );

      expect(foldResult, equals('Success: $data'));
    });

    test('should correctly fold over error for failure case', () {
      const failure = MockFailure('Something went wrong');
      final result = DataResult.failure(failure);

      final foldResult = result.fold(
        (error) => 'Failure: ${error.message}',
        (data) => 'Success: $data',
      );

      expect(foldResult, equals('Failure: Something went wrong'));
    });
  });
}
