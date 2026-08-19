import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/features/orders/domain/entities/order_entity.dart';

abstract class OrderRepository {
  /// One-shot creation, used by the checkout flow after payment succeeds.
  Future<Either<Failure, String>> createOrder(OrderEntity order);

  Future<Either<Failure, List<OrderEntity>>> getCustomerOrders(String customerId);
  Future<Either<Failure, List<OrderEntity>>> getAllOrders();
  Future<Either<Failure, List<OrderEntity>>> getRiderOrders(String riderId);

  /// Live stream — used by the customer tracking screen so status updates
  /// arrive without polling.
  Stream<Either<Failure, OrderEntity>> watchOrder(String orderId);

  Future<Either<Failure, void>> acceptOrder(String orderId);
  Future<Either<Failure, void>> assignRider({
    required String orderId,
    required String riderId,
  });
  Future<Either<Failure, void>> updateOrderStatus({
    required String orderId,
    required String newStatus,
  });
  Future<Either<Failure, void>> cancelOrder({
    required String orderId,
    required String reason,
  });
}
