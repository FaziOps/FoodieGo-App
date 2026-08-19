import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/rating/domain/entities/rating_entity.dart';
import 'package:restaurant_app/features/rating/domain/repositories/rating_repository.dart';

class GetRiderRatingsParams extends Equatable {
  final String riderId;
  const GetRiderRatingsParams(this.riderId);
  @override
  List<Object?> get props => [riderId];
}

class GetRiderRatingsUseCase implements UseCase<List<RatingEntity>, GetRiderRatingsParams> {
  final RatingRepository repository;
  GetRiderRatingsUseCase(this.repository);

  @override
  Future<Either<Failure, List<RatingEntity>>> call(GetRiderRatingsParams params) {
    return repository.getRiderRatings(params.riderId);
  }
}
