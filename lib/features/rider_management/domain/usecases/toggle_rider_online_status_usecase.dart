import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/rider_management/domain/repositories/rider_repository.dart';

class ToggleRiderOnlineStatusParams extends Equatable {
  final String riderId;
  final bool isOnline;

  const ToggleRiderOnlineStatusParams({required this.riderId, required this.isOnline});

  @override
  List<Object?> get props => [riderId, isOnline];
}

class ToggleRiderOnlineStatusUseCase implements UseCase<void, ToggleRiderOnlineStatusParams> {
  final RiderRepository repository;
  ToggleRiderOnlineStatusUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ToggleRiderOnlineStatusParams params) {
    return repository.updateRiderOnlineStatus(params.riderId, params.isOnline);
  }
}
