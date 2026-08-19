import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/rating/domain/repositories/rating_repository.dart';

class GetRiderAverageRatingParams extends Equatable {
  final String riderId;
  const GetRiderAverageRatingParams(this.riderId);
  @override
  List<Object?> get props => [riderId];
}

class GetRiderAverageRatingUseCase implements UseCase<double, GetRiderAverageRatingParams> {
  final RatingRepository repository;
  GetRiderAverageRatingUseCase(this.repository);

  @override
  Future<Either<Failure, double>> call(GetRiderAverageRatingParams params) {
    return repository.getRiderAverageRating(params.riderId);
  }
}
