import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/errors/failures.dart';

abstract class NavigationRepository {
  Future<Either<Failure, void>> launchNavigation({
    required double latitude,
    required double longitude,
  });
}
