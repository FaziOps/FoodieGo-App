import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/core/di/injection_container.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/features/orders/domain/entities/order_entity.dart';
import 'package:restaurant_app/features/orders/domain/usecases/watch_order_status_usecase.dart';
import 'package:restaurant_app/features/orders/presentation/widgets/order_status_stepper.dart';
import 'package:restaurant_app/features/rating/presentation/pages/rate_rider_page.dart';

class OrderDetailPage extends StatelessWidget {
  final String orderId;
  const OrderDetailPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final useCase = sl<WatchOrderStatusUseCase>();
    const primaryOrange = Color(0xFFD35400);
    const secondaryOrange = Color(0xFFE67E22);
    const neutralBackground = Color(0xFF1A1614);
    const darkSurface = Color(0xFF241E1C);
    const creamText = Color(0xFFFDF5E6);

    return Scaffold(
      backgroundColor: neutralBackground,
      appBar: AppBar(
        backgroundColor: neutralBackground,
        elevation: 0,
        title: Text(
          'Order #${orderId.substring(0, orderId.length > 8 ? 8 : orderId.length)}',
          style: const TextStyle(color: creamText, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<Either<Failure, OrderEntity>>(
        stream: useCase(WatchOrderParams(orderId)),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: primaryOrange));
          }
          return snapshot.data!.fold(
            (failure) => Center(child: Text(failure.message, style: const TextStyle(color: creamText))),
            (order) => SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Summary Card
                  Container(
                    decoration: BoxDecoration(
                      color: darkSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Amount', style: TextStyle(color: creamText.withValues(alpha: 0.7))),
                              Text(
                                '\$${order.totalAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: secondaryOrange,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20, color: Colors.white12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Payment Status', style: TextStyle(color: creamText.withValues(alpha: 0.7))),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: order.paymentStatus == 'paid'
                                      ? const Color(0xFF2ECC71).withValues(alpha: 0.15)
                                      : secondaryOrange.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  order.paymentStatus.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: order.paymentStatus == 'paid' ? const Color(0xFF2ECC71) : secondaryOrange,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Order Progress',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: creamText),
                  ),
                  const SizedBox(height: 14),

                  // Stepper
                  Container(
                    decoration: BoxDecoration(
                      color: darkSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: OrderStatusStepper(currentStatus: order.orderStatus),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Items List Summary
                  const Text(
                    'Items Ordered',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: creamText),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: darkSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: order.items.length,
                      separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.white12),
                      itemBuilder: (context, index) {
                        final item = order.items[index];
                        return ListTile(
                          title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w500, color: creamText)),
                          subtitle: Text(
                            'Qty: ${item.quantity} × \$${item.price.toStringAsFixed(2)}',
                            style: TextStyle(color: creamText.withValues(alpha: 0.6)),
                          ),
                          trailing: Text(
                            '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: secondaryOrange),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Delivery Address Card
                  const Text(
                    'Delivery Address',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: creamText),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: darkSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_rounded, color: secondaryOrange, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.deliveryAddress.street,
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: creamText),
                                ),
                                Text(
                                  'Coordinates: (${order.deliveryAddress.latitude.toStringAsFixed(4)}, ${order.deliveryAddress.longitude.toStringAsFixed(4)})',
                                  style: TextStyle(color: creamText.withValues(alpha: 0.6), fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Rate Rider Button if Delivered and not rated yet
                  if (order.orderStatus == 'Delivered' && !order.isRated)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [primaryOrange, secondaryOrange],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: primaryOrange.withValues(alpha: 0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: creamText,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.star_rounded),
                        label: const Text(
                          'Rate your Rider',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RateRiderPage(
                              orderId: order.orderId,
                              riderId: order.riderId ?? '',
                            ),
                          ),
                        ),
                      ),
                    ),

                  if (order.isRated)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: secondaryOrange.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: secondaryOrange.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star_rounded, color: secondaryOrange),
                          const SizedBox(width: 8),
                          Text(
                            'You rated this delivery ${order.ratingStars?.toStringAsFixed(1)} ★',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: creamText),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
