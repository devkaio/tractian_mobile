import 'package:data_result/data_result.dart';
import 'package:tractian_mobile/src/domain/failures/failure_messages.dart';

class UnknownFailure extends Failure {
  final String? _message;

  const UnknownFailure([this._message]) : super();

  @override
  String get message => _message ?? FAILURE.UNKNOWN.message;

  @override
  String toString() => 'UnknownFailure: $message';
}

class NetworkException extends Failure {
  final String? _message;

  const NetworkException([this._message]) : super();

  @override
  String get message => _message ?? FAILURE.NETWORK.message;

  @override
  String toString() => 'NetworkException: $message';
}

class AssetFailure extends Failure {
  final String? _message;

  const AssetFailure([this._message]) : super();

  @override
  String get message => _message ?? FAILURE.ASSET.message;

  @override
  String toString() => 'AssetFailure: $message';
}

class ComponentFailure extends Failure {
  final String? _message;

  const ComponentFailure([this._message]) : super();

  @override
  String get message => _message ?? FAILURE.COMPONENT.message;

  @override
  String toString() => 'ComponentFailure: $message';
}

class LocationFailure extends Failure {
  final String? _message;

  const LocationFailure([this._message]) : super();

  @override
  String get message => _message ?? FAILURE.LOCATION.message;

  @override
  String toString() => 'LocationFailure: $message';
}

class CompanyFailure extends Failure {
  final String? _message;

  const CompanyFailure([this._message]) : super();

  @override
  String get message => _message ?? FAILURE.COMPANY.message;

  @override
  String toString() => 'CompanyFailure: $message';
}
