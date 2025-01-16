import 'package:data_result/data_result.dart';

class AssetFailure extends Failure {
  final String? _message;

  const AssetFailure([this._message]) : super();

  @override
  String get message => _message ?? 'Asset Failure';

  @override
  String toString() => 'AssetFailure: $message';
}

class ComponentFailure extends Failure {
  final String? _message;

  const ComponentFailure([this._message]) : super();

  @override
  String get message => _message ?? 'Component Failure';

  @override
  String toString() => 'ComponentFailure: $message';
}

class LocationFailure extends Failure {
  final String? _message;

  const LocationFailure([this._message]) : super();

  @override
  String get message => _message ?? 'Location Failure';

  @override
  String toString() => 'LocationFailure: $message';
}

class CompanyFailure extends Failure {
  final String? _message;

  const CompanyFailure([this._message]) : super();

  @override
  String get message => _message ?? 'Company Failure';

  @override
  String toString() => 'CompanyFailure: $message';
}
