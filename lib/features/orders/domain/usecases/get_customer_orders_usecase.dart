import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/orders/domain/entities/order_entity.dart';
import 'package:restaurant_app/features/orders/domain/repositories/order_repository.dart';

class GetCustomerOrdersParams extends Equatable {
  final String customerId;
  const GetCustomerOrdersParams(this.customerId);
  @override
  List<Object?> get props => [customerId];
}

class GetCustomerOrdersUseCase
    implements UseCase<List<OrderEntity>, GetCustomerOrdersParams> {
  final OrderRepository repository;
  GetCustomerOrdersUseCase(this.repository);

  @override
  Future<Either<Failure, List<OrderEntity>>> call(GetCustomerOrdersParams params) {
    return repository.getCustomerOrders(params.customerId);
  }
}
