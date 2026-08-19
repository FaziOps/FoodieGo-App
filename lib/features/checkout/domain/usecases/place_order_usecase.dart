import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:restaurant_app/features/orders/domain/entities/order_entity.dart';

/// This is the ONLY place allowed to write an order to Firestore with
/// paymentStatus: 'paid'. Guard the caller (CheckoutBloc) so it never
/// invokes this before ConfirmPaymentUseCase has returned isSuccess.
class PlaceOrderUseCase implements UseCase<String, OrderEntity> {
  final CheckoutRepository repository;
  PlaceOrderUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(OrderEntity params) {
    return repository.placeOrder(params);
  }
}
