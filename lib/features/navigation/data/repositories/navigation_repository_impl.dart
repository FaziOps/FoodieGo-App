import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/errors/exceptions.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/features/navigation/data/datasources/maps_launcher_data_source.dart';
import 'package:restaurant_app/features/navigation/domain/repositories/navigation_repository.dart';

class NavigationRepositoryImpl implements NavigationRepository {
  final MapsLauncherDataSource dataSource;
  NavigationRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, void>> launchNavigation({
    required double latitude,
    required double longitude,
  }) async {
    try {
      await dataSource.launch(latitude: latitude, longitude: longitude);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
