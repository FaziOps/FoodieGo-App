import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/core/constants/app_constants.dart';
import 'package:restaurant_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:restaurant_app/features/checkout/domain/usecases/confirm_payment_usecase.dart';
import 'package:restaurant_app/features/checkout/domain/usecases/create_payment_intent_usecase.dart';
import 'package:restaurant_app/features/checkout/domain/usecases/place_order_usecase.dart';
import 'package:restaurant_app/features/orders/domain/entities/delivery_address_entity.dart';
import 'package:restaurant_app/features/orders/domain/entities/order_entity.dart';
import 'package:restaurant_app/features/orders/domain/entities/order_item_entity.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

/// Owns the whole "pay then place order" sequence so no other layer can
/// accidentally place an order before payment actually succeeds. Note this
/// bloc never touches the Stripe SDK directly — presenting the payment
/// sheet lives in StripeDataSource (data layer), reached only through
/// ConfirmPaymentUseCase. Keeps the dependency rule intact: presentation
/// talks to domain only.
class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CreatePaymentIntentUseCase createPaymentIntentUseCase;
  final ConfirmPaymentUseCase confirmPaymentUseCase;
  final PlaceOrderUseCase placeOrderUseCase;

  CheckoutBloc({
    required this.createPaymentIntentUseCase,
    required this.confirmPaymentUseCase,
    required this.placeOrderUseCase,
  }) : super(const CheckoutInitial()) {
    on<PlaceOrderRequested>(_onPlaceOrderRequested);
  }

  Future<void> _onPlaceOrderRequested(
    PlaceOrderRequested event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const CheckoutProcessingPayment());

    final intentResult = await createPaymentIntentUseCase(
      CreatePaymentIntentParams(amount: event.totalAmount),
    );

    String? clientSecret;
    final intentFailure = intentResult.fold((f) => f, (secret) {
      clientSecret = secret;
      return null;
    });
    if (intentFailure != null) {
      emit(CheckoutFailureState(intentFailure.message));
      return;
    }

    final confirmResult = await confirmPaymentUseCase(ConfirmPaymentParams(clientSecret!));

    final paymentSucceeded = confirmResult.fold((f) => false, (result) => result.isSuccess);
    if (!paymentSucceeded) {
      final message = confirmResult.fold((f) => f.message, (_) => 'Payment was not successful.');
      emit(CheckoutFailureState(message));
      return;
    }

    emit(const CheckoutPlacingOrder());

    final order = OrderEntity(
      orderId: '',
      customerId: event.customerId,
      items: event.cartItems
          .map((c) => OrderItemEntity(
                itemId: c.itemId,
                name: c.name,
                quantity: c.quantity,
                price: c.price,
              ))
          .toList(),
      totalAmount: event.totalAmount,
      paymentStatus: 'paid',
      stripePaymentIntentId: confirmResult.fold((f) => null, (r) => r.paymentIntentId),
      orderStatus: AppConstants.statusPlaced,
      deliveryAddress: event.deliveryAddress,
      createdAt: DateTime.now(),
    );

    final orderResult = await placeOrderUseCase(order);
    orderResult.fold(
      (failure) => emit(CheckoutFailureState(failure.message)),
      (orderId) => emit(CheckoutSuccess(orderId)),
    );
  }
}
