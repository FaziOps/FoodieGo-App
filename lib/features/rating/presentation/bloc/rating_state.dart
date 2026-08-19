part of 'rating_bloc.dart';

abstract class RatingState extends Equatable {
  const RatingState();
  @override
  List<Object?> get props => [];
}

class RatingInitial extends RatingState {
  const RatingInitial();
}

class RatingSubmitting extends RatingState {
  const RatingSubmitting();
}

class RatingSubmitted extends RatingState {
  const RatingSubmitted();
}

class RiderRatingsLoading extends RatingState {
  const RiderRatingsLoading();
}

class RiderRatingsLoaded extends RatingState {
  final List<RatingEntity> ratings;
  const RiderRatingsLoaded(this.ratings);
  @override
  List<Object?> get props => [ratings];
}

class RatingError extends RatingState {
  final String message;
  const RatingError(this.message);
  @override
  List<Object?> get props => [message];
}
