import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant_app/core/errors/failures.dart';

/// Every use case has exactly one public method: call().
/// Type   = what it returns on success.
/// Params = its input. Use [NoParams] when it needs nothing.
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Same contract but for use cases that expose a live Firestore stream
/// (order tracking, admin dashboard) instead of a one-shot Future.
abstract class StreamUseCase<T, Params> {
  Stream<Either<Failure, T>> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();
  @override
  List<Object?> get props => [];
}
