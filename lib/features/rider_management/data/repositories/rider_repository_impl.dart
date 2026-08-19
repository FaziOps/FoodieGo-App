import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/errors/exceptions.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/network/network_info.dart';
import 'package:restaurant_app/features/rider_management/data/datasources/rider_remote_data_source.dart';
import 'package:restaurant_app/features/rider_management/domain/entities/rider_entity.dart';
import 'package:restaurant_app/features/rider_management/domain/repositories/rider_repository.dart';

class RiderRepositoryImpl implements RiderRepository {
  final RiderRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  RiderRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<RiderEntity>>> getAvailableRiders() async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      return Right(await remoteDataSource.getAvailableRiders());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateRiderOnlineStatus(String riderId, bool isOnline) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      await remoteDataSource.updateRiderOnlineStatus(riderId, isOnline);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
