import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/orders/domain/entities/order_entity.dart';
import 'package:restaurant_app/features/orders/domain/repositories/order_repository.dart';

class WatchOrderParams extends Equatable {
  final String orderId;
  const WatchOrderParams(this.orderId);
  @override
  List<Object?> get props => [orderId];
}

/// Powers the customer-facing live tracking screen.
class WatchOrderStatusUseCase implements StreamUseCase<OrderEntity, WatchOrderParams> {
  final OrderRepository repository;
  WatchOrderStatusUseCase(this.repository);

  @override
  Stream<Either<Failure, OrderEntity>> call(WatchOrderParams params) {
    return repository.watchOrder(params.orderId);
  }
}
