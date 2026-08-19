part of 'checkout_bloc.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();
  @override
  List<Object?> get props => [];
}

class CheckoutInitial extends CheckoutState {
  const CheckoutInitial();
}

class CheckoutProcessingPayment extends CheckoutState {
  const CheckoutProcessingPayment();
}

class CheckoutPlacingOrder extends CheckoutState {
  const CheckoutPlacingOrder();
}

class CheckoutSuccess extends CheckoutState {
  final String orderId;
  const CheckoutSuccess(this.orderId);
  @override
  List<Object?> get props => [orderId];
}

class CheckoutFailureState extends CheckoutState {
  final String message;
  const CheckoutFailureState(this.message);
  @override
  List<Object?> get props => [message];
}
