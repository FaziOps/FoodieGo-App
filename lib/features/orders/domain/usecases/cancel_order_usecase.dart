import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/orders/domain/repositories/order_repository.dart';

class CancelOrderParams extends Equatable {
  final String orderId;
  final String reason;
  const CancelOrderParams({required this.orderId, required this.reason});
  @override
  List<Object?> get props => [orderId, reason];
}

/// P2 in the PRD. Wired end-to-end here; refund handling (Stripe reversal)
/// is a TODO left for when Open Decision #2 in the PRD is answered.
class CancelOrderUseCase implements UseCase<void, CancelOrderParams> {
  final OrderRepository repository;
  CancelOrderUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CancelOrderParams params) {
    return repository.cancelOrder(orderId: params.orderId, reason: params.reason);
  }
}
