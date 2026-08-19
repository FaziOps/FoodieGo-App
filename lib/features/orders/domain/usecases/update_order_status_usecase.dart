import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/orders/domain/repositories/order_repository.dart';

class UpdateOrderStatusParams extends Equatable {
  final String orderId;
  final String newStatus;
  const UpdateOrderStatusParams({required this.orderId, required this.newStatus});
  @override
  List<Object?> get props => [orderId, newStatus];
}

/// Rider only: Picked Up -> On the Way -> Delivered.
/// Validity of the transition is enforced server-side (Firestore rules) —
/// this use case just forwards intent.
class UpdateOrderStatusUseCase implements UseCase<void, UpdateOrderStatusParams> {
  final OrderRepository repository;
  UpdateOrderStatusUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateOrderStatusParams params) {
    return repository.updateOrderStatus(
      orderId: params.orderId,
      newStatus: params.newStatus,
    );
  }
}
