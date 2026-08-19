import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/orders/domain/repositories/order_repository.dart';

class AssignRiderParams extends Equatable {
  final String orderId;
  final String riderId;
  const AssignRiderParams({required this.orderId, required this.riderId});
  @override
  List<Object?> get props => [orderId, riderId];
}

/// Admin only: attaches riderId, advances status -> "Preparing".
class AssignRiderUseCase implements UseCase<void, AssignRiderParams> {
  final OrderRepository repository;
  AssignRiderUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AssignRiderParams params) {
    return repository.assignRider(orderId: params.orderId, riderId: params.riderId);
  }
}
