import 'package:flutter_test/flutter_test.dart';
import 'package:tractian_mobile/src/domain/failures/failure_messages.dart';
import 'package:tractian_mobile/src/domain/failures/repository_failures.dart';

void main() {
  group('UnknownFailure', () {
    test('should return default message when no message is provided', () {
      const failure = UnknownFailure();
      expect(failure.message, FAILURE.UNKNOWN.message);
    });

    test('should return provided message', () {
      const message = 'Custom unknown failure message';
      const failure = UnknownFailure(message);
      expect(failure.message, message);
    });

    test('toString should return correct format', () {
      const message = 'Custom unknown failure message';
      const failure = UnknownFailure(message);
      expect(failure.toString(), 'UnknownFailure: $message');
    });
  });

  group('NetworkException', () {
    test('should return default message when no message is provided', () {
      const failure = NetworkException();
      expect(failure.message, FAILURE.NETWORK.message);
    });

    test('should return provided message', () {
      const message = 'Custom network exception message';
      const failure = NetworkException(message);
      expect(failure.message, message);
    });

    test('toString should return correct format', () {
      const message = 'Custom network exception message';
      const failure = NetworkException(message);
      expect(failure.toString(), 'NetworkException: $message');
    });
  });

  group('AssetFailure', () {
    test('should return default message when no message is provided', () {
      const failure = AssetFailure();
      expect(failure.message, FAILURE.ASSET.message);
    });

    test('should return provided message', () {
      const message = 'Custom asset failure message';
      const failure = AssetFailure(message);
      expect(failure.message, message);
    });

    test('toString should return correct format', () {
      const message = 'Custom asset failure message';
      const failure = AssetFailure(message);
      expect(failure.toString(), 'AssetFailure: $message');
    });
  });

  group('ComponentFailure', () {
    test('should return default message when no message is provided', () {
      const failure = ComponentFailure();
      expect(failure.message, FAILURE.COMPONENT.message);
    });

    test('should return provided message', () {
      const message = 'Custom component failure message';
      const failure = ComponentFailure(message);
      expect(failure.message, message);
    });

    test('toString should return correct format', () {
      const message = 'Custom component failure message';
      const failure = ComponentFailure(message);
      expect(failure.toString(), 'ComponentFailure: $message');
    });
  });

  group('LocationFailure', () {
    test('should return default message when no message is provided', () {
      const failure = LocationFailure();
      expect(failure.message, FAILURE.LOCATION.message);
    });

    test('should return provided message', () {
      const message = 'Custom location failure message';
      const failure = LocationFailure(message);
      expect(failure.message, message);
    });

    test('toString should return correct format', () {
      const message = 'Custom location failure message';
      const failure = LocationFailure(message);
      expect(failure.toString(), 'LocationFailure: $message');
    });
  });

  group('CompanyFailure', () {
    test('should return default message when no message is provided', () {
      const failure = CompanyFailure();
      expect(failure.message, FAILURE.COMPANY.message);
    });

    test('should return provided message', () {
      const message = 'Custom company failure message';
      const failure = CompanyFailure(message);
      expect(failure.message, message);
    });

    test('toString should return correct format', () {
      const message = 'Custom company failure message';
      const failure = CompanyFailure(message);
      expect(failure.toString(), 'CompanyFailure: $message');
    });
  });
}
