import 'package:equatable/equatable.dart';

class RatingEntity extends Equatable {
  final String orderId;
  final String riderId;
  final int stars; // 1-5
  final String review;

  const RatingEntity({
    required this.orderId,
    required this.riderId,
    required this.stars,
    required this.review,
  });

  @override
  List<Object?> get props => [orderId, riderId, stars, review];
}
