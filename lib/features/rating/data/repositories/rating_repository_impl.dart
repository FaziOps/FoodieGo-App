import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/errors/exceptions.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/network/network_info.dart';
import 'package:restaurant_app/features/rating/data/datasources/rating_remote_data_source.dart';
import 'package:restaurant_app/features/rating/data/models/rating_model.dart';
import 'package:restaurant_app/features/rating/domain/entities/rating_entity.dart';
import 'package:restaurant_app/features/rating/domain/repositories/rating_repository.dart';

class RatingRepositoryImpl implements RatingRepository {
  final RatingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  RatingRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, void>> submitRating(RatingEntity rating) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      await remoteDataSource.submitRating(RatingModel(
        orderId: rating.orderId,
        riderId: rating.riderId,
        stars: rating.stars,
        review: rating.review,
      ));
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<RatingEntity>>> getRiderRatings(String riderId) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      return Right(await remoteDataSource.getRiderRatings(riderId));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, double>> getRiderAverageRating(String riderId) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      return Right(await remoteDataSource.getRiderAverageRating(riderId));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
