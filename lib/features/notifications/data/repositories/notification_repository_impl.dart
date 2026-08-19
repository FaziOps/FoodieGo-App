import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/errors/exceptions.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/features/notifications/data/datasources/fcm_data_source.dart';
import 'package:restaurant_app/features/notifications/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final FCMDataSource dataSource;
  NotificationRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, void>> registerDeviceToken(String userId) async {
    try {
      await dataSource.registerToken(userId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> sendOrderStatusNotification({
    required String userId,
    required String orderId,
    required String newStatus,
  }) async {
    try {
      await dataSource.sendNotification(
        userId: userId,
        title: 'Order update',
        body: 'Your order is now: $newStatus',
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
