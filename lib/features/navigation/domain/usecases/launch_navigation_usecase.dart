import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/navigation/domain/repositories/navigation_repository.dart';

class LaunchNavigationParams extends Equatable {
  final double latitude;
  final double longitude;
  const LaunchNavigationParams({required this.latitude, required this.longitude});
  @override
  List<Object?> get props => [latitude, longitude];
}

/// Single call, no branching logic — kept as its own use case anyway so
/// the Rider presentation layer never imports url_launcher directly.
class LaunchNavigationUseCase implements UseCase<void, LaunchNavigationParams> {
  final NavigationRepository repository;
  LaunchNavigationUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(LaunchNavigationParams params) {
    return repository.launchNavigation(
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}
