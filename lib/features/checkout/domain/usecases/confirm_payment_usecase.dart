import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/checkout/domain/entities/payment_result_entity.dart';
import 'package:restaurant_app/features/checkout/domain/repositories/checkout_repository.dart';

class ConfirmPaymentParams extends Equatable {
  final String clientSecret;
  const ConfirmPaymentParams(this.clientSecret);
  @override
  List<Object?> get props => [clientSecret];
}

class ConfirmPaymentUseCase implements UseCase<PaymentResultEntity, ConfirmPaymentParams> {
  final CheckoutRepository repository;
  ConfirmPaymentUseCase(this.repository);

  @override
  Future<Either<Failure, PaymentResultEntity>> call(ConfirmPaymentParams params) {
    return repository.confirmPayment(params.clientSecret);
  }
}
