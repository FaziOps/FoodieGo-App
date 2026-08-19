import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/rating/domain/entities/rating_entity.dart';
import 'package:restaurant_app/features/rating/domain/usecases/get_rider_ratings_usecase.dart';
import 'package:restaurant_app/features/rating/domain/usecases/submit_rating_usecase.dart';

part 'rating_event.dart';
part 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final SubmitRatingUseCase submitRatingUseCase;
  final GetRiderRatingsUseCase getRiderRatingsUseCase;

  RatingBloc({
    required this.submitRatingUseCase,
    required this.getRiderRatingsUseCase,
  }) : super(const RatingInitial()) {
    on<SubmitRatingEvent>(_onSubmit);
    on<LoadRiderRatingsEvent>(_onLoad);
  }

  Future<void> _onSubmit(SubmitRatingEvent event, Emitter<RatingState> emit) async {
    emit(const RatingSubmitting());
    final result = await submitRatingUseCase(event.rating);
    result.fold(
      (failure) => emit(RatingError(failure.message)),
      (_) => emit(const RatingSubmitted()),
    );
  }

  Future<void> _onLoad(LoadRiderRatingsEvent event, Emitter<RatingState> emit) async {
    emit(const RiderRatingsLoading());
    final result = await getRiderRatingsUseCase(GetRiderRatingsParams(event.riderId));
    result.fold(
      (failure) => emit(RatingError(failure.message)),
      (ratings) => emit(RiderRatingsLoaded(ratings)),
    );
  }
}
