import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/features/rating/domain/entities/rating_entity.dart';

abstract class RatingRepository {
  Future<Either<Failure, void>> submitRating(RatingEntity rating);
  Future<Either<Failure, List<RatingEntity>>> getRiderRatings(String riderId);
  Future<Either<Failure, double>> getRiderAverageRating(String riderId);
}
