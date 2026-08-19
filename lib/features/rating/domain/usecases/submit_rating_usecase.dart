import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/rating/domain/entities/rating_entity.dart';
import 'package:restaurant_app/features/rating/domain/repositories/rating_repository.dart';

class SubmitRatingUseCase implements UseCase<void, RatingEntity> {
  final RatingRepository repository;
  SubmitRatingUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RatingEntity params) {
    if (params.stars < 1 || params.stars > 5) {
      return Future.value(const Left(ValidationFailure('Rating must be between 1 and 5.')));
    }
    return repository.submitRating(params);
  }
}
