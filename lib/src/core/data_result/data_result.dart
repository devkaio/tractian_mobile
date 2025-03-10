import 'failure.dart';

abstract class DataResult<S> {
  const DataResult();

  factory DataResult.failure(Failure failure) = _FailureResult<S>;
  factory DataResult.success(S data) = _SuccessResult<S>;

  Failure? get error => fold<Failure?>(
        (error) => error,
        (data) => null,
      );

  S? get data => fold<S?>(
        (error) => null,
        (data) => data,
      );

  T fold<T>(
    T Function(Failure error) fnFailure,
    T Function(S data) fnData,
  );

  bool get isSuccess;

  bool get isFailure;
}

class _SuccessResult<S> extends DataResult<S> {
  const _SuccessResult(this._value);
  final S _value;

  @override
  T fold<T>(
    T Function(Failure error) fnFailure,
    T Function(S data) fnData,
  ) {
    return fnData(_value);
  }

  @override
  bool get isFailure => false;

  @override
  bool get isSuccess => true;
}

class _FailureResult<S> extends DataResult<S> {
  const _FailureResult(this._value);

  final Failure _value;

  @override
  T fold<T>(
    T Function(Failure error) fnFailure,
    T Function(S data) fnData,
  ) {
    return fnFailure(_value);
  }

  @override
  bool get isSuccess => false;

  @override
  bool get isFailure => true;
}
