import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/rider_management/domain/entities/rider_entity.dart';
import 'package:restaurant_app/features/rider_management/domain/repositories/rider_repository.dart';

/// Feeds the AssignRiderDialog in the orders feature — only riders who
/// are currently online (Open Decision #4 in the PRD) show up here.
class GetAvailableRidersUseCase implements UseCase<List<RiderEntity>, NoParams> {
  final RiderRepository repository;
  GetAvailableRidersUseCase(this.repository);

  @override
  Future<Either<Failure, List<RiderEntity>>> call(NoParams params) {
    return repository.getAvailableRiders();
  }
}
