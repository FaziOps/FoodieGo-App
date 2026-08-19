import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/core/di/injection_container.dart';
import 'package:restaurant_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:restaurant_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:restaurant_app/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:restaurant_app/features/checkout/presentation/widgets/address_form.dart';
import 'package:restaurant_app/features/checkout/presentation/widgets/payment_method_selector.dart';
import 'package:restaurant_app/features/checkout/presentation/widgets/payment_summary_card.dart';
import 'package:restaurant_app/features/orders/domain/entities/delivery_address_entity.dart';
import 'package:restaurant_app/features/orders/presentation/pages/my_orders_page.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CheckoutBloc>(),
      child: const _CheckoutPageContent(),
    );
  }
}

class _CheckoutPageContent extends StatefulWidget {
  const _CheckoutPageContent();

  @override
  State<_CheckoutPageContent> createState() => _CheckoutPageContentState();
}

class _CheckoutPageContentState extends State<_CheckoutPageContent> {
  final _streetController = TextEditingController(text: '742 Evergreen Terrace');
  final _latController = TextEditingController(text: '37.7749');
  final _lngController = TextEditingController(text: '-122.4194');

  PaymentGatewayType _selectedGateway = PaymentGatewayType.stripeCard;
  Map<String, String>? _cardData;

  @override
  void dispose() {
    _streetController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  String _getGatewayLabel() {
    switch (_selectedGateway) {
      case PaymentGatewayType.stripeCard:
        return 'Stripe Card';
      case PaymentGatewayType.googlePay:
        return 'Google Pay';
      case PaymentGatewayType.payPal:
        return 'PayPal';
      case PaymentGatewayType.cashOnDelivery:
        return 'Cash on Delivery';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartState = context.watch<CartBloc>().state;
    final authState = context.watch<AuthBloc>().state;

    const primaryOrange = Color(0xFFD35400);
    const secondaryOrange = Color(0xFFE67E22);
    const neutralBackground = Color(0xFF1A1614);
    const darkSurface = Color(0xFF241E1C);
    const creamText = Color(0xFFFDF5E6);

    if (cartState is! CartLoaded || cartState.items.isEmpty) {
      return Scaffold(
        backgroundColor: neutralBackground,
        appBar: AppBar(
          backgroundColor: neutralBackground,
          elevation: 0,
          title: const Text('Checkout', style: TextStyle(color: creamText, fontWeight: FontWeight.bold)),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_bag_outlined, size: 72, color: secondaryOrange.withValues(alpha: 0.6)),
                const SizedBox(height: 16),
                const Text(
                  'Your cart is currently empty.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: creamText),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add delicious meals to your cart before checking out.',
                  style: TextStyle(color: creamText.withValues(alpha: 0.6)),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    foregroundColor: creamText,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Back to Menu'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final double grandTotal = cartState.total + 2.99; // Total + $2.99 Delivery Fee
    final String customerId = authState is AuthAuthenticated
        ? authState.user.uid
        : fb.FirebaseAuth.instance.currentUser?.uid ?? '';

    if (customerId.isEmpty) {
      return Scaffold(
        backgroundColor: neutralBackground,
        appBar: AppBar(
          backgroundColor: neutralBackground,
          elevation: 0,
          title: const Text('Checkout', style: TextStyle(color: creamText, fontWeight: FontWeight.bold)),
        ),
        body: const Center(
          child: Text(
            'Authentication required. Please log in to complete checkout.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: creamText),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: neutralBackground,
      appBar: AppBar(
        backgroundColor: neutralBackground,
        elevation: 0,
        title: const Text('Checkout & Payment', style: TextStyle(color: creamText, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: BlocConsumer<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutSuccess) {
            context.read<CartBloc>().add(const ClearCartEvent());
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyOrdersPage()),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('🎉 Order placed via ${_getGatewayLabel()}! Tracking activated.'),
                backgroundColor: const Color(0xFF2ECC71),
                duration: const Duration(seconds: 4),
              ),
            );
          } else if (state is CheckoutFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent),
            );
          }
        },
        builder: (context, state) {
          final isBusy = state is CheckoutProcessingPayment || state is CheckoutPlacingOrder;
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step 1: Order Summary
                PaymentSummaryCard(items: cartState.items, total: cartState.total),
                const SizedBox(height: 20),

                // Step 2: Delivery Address
                AddressForm(
                  streetController: _streetController,
                  latController: _latController,
                  lngController: _lngController,
                ),
                const SizedBox(height: 20),

                // Step 3: Payment Gateway Selector & Form
                PaymentMethodSelector(
                  onPaymentMethodChanged: (gateway, cardData) {
                    setState(() {
                      _selectedGateway = gateway;
                      _cardData = cardData;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Security Guarantee Banner
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: darkSurface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF2ECC71).withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_user_rounded, color: Color(0xFF2ECC71), size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Encrypted 256-bit SSL transaction via secure Payment Gateway.',
                          style: TextStyle(fontSize: 12, color: creamText.withValues(alpha: 0.8)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Action Button
                isBusy
                    ? Center(
                        child: Column(
                          children: [
                            const CircularProgressIndicator(color: primaryOrange),
                            const SizedBox(height: 12),
                            Text(
                              'Processing payment via ${_getGatewayLabel()}...',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: creamText),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [primaryOrange, secondaryOrange],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: primaryOrange.withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: creamText,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: Icon(
                            _selectedGateway == PaymentGatewayType.cashOnDelivery
                                ? Icons.shopping_cart_checkout_rounded
                                : Icons.lock_outline_rounded,
                            size: 20,
                          ),
                          label: Text(
                            _selectedGateway == PaymentGatewayType.cashOnDelivery
                                ? 'Place Order (\$${grandTotal.toStringAsFixed(2)} - COD)'
                                : 'Pay \$${grandTotal.toStringAsFixed(2)} with ${_getGatewayLabel()}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                          ),
                          onPressed: () {
                            if (_streetController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a delivery street address'),
                                  backgroundColor: primaryOrange,
                                ),
                              );
                              return;
                            }

                            if (_selectedGateway == PaymentGatewayType.stripeCard &&
                                (_cardData == null ||
                                    _cardData!['cardNumber']!.length < 12)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a valid card number'),
                                  backgroundColor: primaryOrange,
                                ),
                              );
                              return;
                            }

                            final double lat = double.tryParse(_latController.text) ?? 37.7749;
                            final double lng = double.tryParse(_lngController.text) ?? -122.4194;

                            final address = DeliveryAddressEntity(
                              street: _streetController.text.trim(),
                              latitude: lat,
                              longitude: lng,
                            );

                            context.read<CheckoutBloc>().add(
                                  PlaceOrderRequested(
                                    customerId: customerId,
                                    cartItems: cartState.items,
                                    totalAmount: grandTotal,
                                    deliveryAddress: address,
                                  ),
                                );
                          },
                        ),
                      ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
