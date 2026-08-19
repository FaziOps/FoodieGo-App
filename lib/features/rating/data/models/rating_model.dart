import 'package:restaurant_app/features/rating/domain/entities/rating_entity.dart';

class RatingModel extends RatingEntity {
  const RatingModel({
    required super.orderId,
    required super.riderId,
    required super.stars,
    required super.review,
  });

  Map<String, dynamic> toOrderRatingMap() => {'stars': stars, 'review': review};
}
