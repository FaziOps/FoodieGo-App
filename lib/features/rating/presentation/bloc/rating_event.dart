part of 'rating_bloc.dart';

abstract class RatingEvent extends Equatable {
  const RatingEvent();
  @override
  List<Object?> get props => [];
}

class SubmitRatingEvent extends RatingEvent {
  final RatingEntity rating;
  const SubmitRatingEvent(this.rating);
  @override
  List<Object?> get props => [rating];
}

class LoadRiderRatingsEvent extends RatingEvent {
  final String riderId;
  const LoadRiderRatingsEvent(this.riderId);
  @override
  List<Object?> get props => [riderId];
}
