import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/errors/failures.dart';

abstract class NotificationRepository {
  Future<Either<Failure, void>> registerDeviceToken(String userId);
  Future<Either<Failure, void>> sendOrderStatusNotification({
    required String userId,
    required String orderId,
    required String newStatus,
  });
}
