import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/notifications/domain/repositories/notification_repository.dart';

class SendOrderStatusNotificationParams extends Equatable {
  final String userId;
  final String orderId;
  final String newStatus;
  const SendOrderStatusNotificationParams({
    required this.userId,
    required this.orderId,
    required this.newStatus,
  });
  @override
  List<Object?> get props => [userId, orderId, newStatus];
}

/// Fired by admin/rider flows whenever they change an order's status —
/// wire a call to this into AdminOrdersBloc/RiderOrdersBloc once a Cloud
/// Function or server-side trigger exists to actually push the message.
class SendOrderStatusNotificationUseCase
    implements UseCase<void, SendOrderStatusNotificationParams> {
  final NotificationRepository repository;
  SendOrderStatusNotificationUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SendOrderStatusNotificationParams params) {
    return repository.sendOrderStatusNotification(
      userId: params.userId,
      orderId: params.orderId,
      newStatus: params.newStatus,
    );
  }
}
