import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/orders/domain/repositories/order_repository.dart';

class AcceptOrderParams extends Equatable {
  final String orderId;
  const AcceptOrderParams(this.orderId);
  @override
  List<Object?> get props => [orderId];
}

/// Admin only: "Order Placed" -> "Accepted".
class AcceptOrderUseCase implements UseCase<void, AcceptOrderParams> {
  final OrderRepository repository;
  AcceptOrderUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AcceptOrderParams params) {
    return repository.acceptOrder(params.orderId);
  }
}
