import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/orders/domain/entities/order_entity.dart';
import 'package:restaurant_app/features/orders/domain/repositories/order_repository.dart';

class GetRiderOrdersParams extends Equatable {
  final String riderId;
  const GetRiderOrdersParams(this.riderId);
  @override
  List<Object?> get props => [riderId];
}

class GetRiderOrdersUseCase implements UseCase<List<OrderEntity>, GetRiderOrdersParams> {
  final OrderRepository repository;
  GetRiderOrdersUseCase(this.repository);

  @override
  Future<Either<Failure, List<OrderEntity>>> call(GetRiderOrdersParams params) {
    return repository.getRiderOrders(params.riderId);
  }
}
