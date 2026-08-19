import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/features/rider_management/domain/entities/rider_entity.dart';

abstract class RiderRepository {
  Future<Either<Failure, List<RiderEntity>>> getAvailableRiders();
  Future<Either<Failure, void>> updateRiderOnlineStatus(String riderId, bool isOnline);
}
