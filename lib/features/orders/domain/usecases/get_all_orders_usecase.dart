import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/orders/domain/entities/order_entity.dart';
import 'package:restaurant_app/features/orders/domain/repositories/order_repository.dart';

/// Admin only.
class GetAllOrdersUseCase implements UseCase<List<OrderEntity>, NoParams> {
  final OrderRepository repository;
  GetAllOrdersUseCase(this.repository);

  @override
  Future<Either<Failure, List<OrderEntity>>> call(NoParams params) {
    return repository.getAllOrders();
  }
}
