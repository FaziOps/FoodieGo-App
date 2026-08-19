import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/notifications/domain/repositories/notification_repository.dart';

class RegisterDeviceTokenParams extends Equatable {
  final String userId;
  const RegisterDeviceTokenParams(this.userId);
  @override
  List<Object?> get props => [userId];
}

/// Called once right after login so this device can receive order updates.
class RegisterDeviceTokenUseCase implements UseCase<void, RegisterDeviceTokenParams> {
  final NotificationRepository repository;
  RegisterDeviceTokenUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RegisterDeviceTokenParams params) {
    return repository.registerDeviceToken(params.userId);
  }
}
