import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/features/checkout/domain/entities/payment_result_entity.dart';
import 'package:restaurant_app/features/orders/domain/entities/order_entity.dart';

abstract class CheckoutRepository {
  /// Starts a Stripe PaymentIntent in sandbox mode for [amount] (in the
  /// smallest currency unit, e.g. cents).
  Future<Either<Failure, String>> createPaymentIntent({
    required double amount,
    required String currency,
  });

  /// Presents Stripe's payment sheet and confirms the intent.
  Future<Either<Failure, PaymentResultEntity>> confirmPayment(String clientSecret);

  /// Writes the order to Firestore. Caller (the use case) must only
  /// invoke this after confirmPayment() reports success.
  Future<Either<Failure, String>> placeOrder(OrderEntity order);
}
