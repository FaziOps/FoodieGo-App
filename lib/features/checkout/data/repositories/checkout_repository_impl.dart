import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/errors/exceptions.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/network/network_info.dart';
import 'package:restaurant_app/features/checkout/data/datasources/stripe_data_source.dart';
import 'package:restaurant_app/features/checkout/domain/entities/payment_result_entity.dart';
import 'package:restaurant_app/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:restaurant_app/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:restaurant_app/features/orders/data/models/order_model.dart';
import 'package:restaurant_app/features/orders/domain/entities/order_entity.dart';

/// Deliberately depends on OrderRemoteDataSource from the `orders` feature
/// rather than duplicating Firestore order-writing logic — see the
/// architecture doc's note on this.
class CheckoutRepositoryImpl implements CheckoutRepository {
  final StripeDataSource stripeDataSource;
  final OrderRemoteDataSource orderRemoteDataSource;
  final NetworkInfo networkInfo;

  CheckoutRepositoryImpl({
    required this.stripeDataSource,
    required this.orderRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, String>> createPaymentIntent({
    required double amount,
    required String currency,
  }) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final secret = await stripeDataSource.createPaymentIntentClientSecret(
        amount: amount,
        currency: currency,
      );
      return Right(secret);
    } on ServerException catch (e) {
      return Left(PaymentFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, PaymentResultEntity>> confirmPayment(String clientSecret) async {
    try {
      final result = await stripeDataSource.confirmPayment(clientSecret);
      return Right(result);
    } on ServerException catch (e) {
      return Left(PaymentFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> placeOrder(OrderEntity order) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final model = OrderModel(
        orderId: order.orderId,
        customerId: order.customerId,
        riderId: order.riderId,
        items: order.items,
        totalAmount: order.totalAmount,
        paymentStatus: order.paymentStatus,
        stripePaymentIntentId: order.stripePaymentIntentId,
        orderStatus: order.orderStatus,
        deliveryAddress: order.deliveryAddress,
        createdAt: order.createdAt,
      );
      final id = await orderRemoteDataSource.createOrder(model);
      return Right(id);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
