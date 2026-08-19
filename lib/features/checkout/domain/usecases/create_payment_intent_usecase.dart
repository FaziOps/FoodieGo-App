import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/checkout/domain/repositories/checkout_repository.dart';

class CreatePaymentIntentParams extends Equatable {
  final double amount;
  final String currency;
  const CreatePaymentIntentParams({required this.amount, this.currency = 'usd'});
  @override
  List<Object?> get props => [amount, currency];
}

class CreatePaymentIntentUseCase implements UseCase<String, CreatePaymentIntentParams> {
  final CheckoutRepository repository;
  CreatePaymentIntentUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(CreatePaymentIntentParams params) {
    return repository.createPaymentIntent(amount: params.amount, currency: params.currency);
  }
}
