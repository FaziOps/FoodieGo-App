part of 'checkout_bloc.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();
  @override
  List<Object?> get props => [];
}

class PlaceOrderRequested extends CheckoutEvent {
  final String customerId;
  final List<CartItemEntity> cartItems;
  final double totalAmount;
  final DeliveryAddressEntity deliveryAddress;

  const PlaceOrderRequested({
    required this.customerId,
    required this.cartItems,
    required this.totalAmount,
    required this.deliveryAddress,
  });

  @override
  List<Object?> get props => [customerId, cartItems, totalAmount, deliveryAddress];
}
