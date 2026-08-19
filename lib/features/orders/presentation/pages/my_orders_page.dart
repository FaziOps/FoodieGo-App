import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/core/di/injection_container.dart';
import 'package:restaurant_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:restaurant_app/features/orders/presentation/bloc/customer_orders_bloc.dart';
import 'package:restaurant_app/features/orders/presentation/pages/order_detail_page.dart';
import 'package:restaurant_app/features/orders/presentation/widgets/order_card.dart';
import 'package:restaurant_app/features/rating/presentation/pages/rate_rider_page.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final String customerId = authState is AuthAuthenticated
        ? authState.user.uid
        : fb.FirebaseAuth.instance.currentUser?.uid ?? '';

    return BlocProvider(
      create: (_) => sl<CustomerOrdersBloc>()..add(LoadCustomerOrders(customerId)),
      child: _MyOrdersContent(customerId: customerId),
    );
  }
}

class _MyOrdersContent extends StatelessWidget {
  final String customerId;
  const _MyOrdersContent({required this.customerId});

  @override
  Widget build(BuildContext context) {
    const primaryOrange = Color(0xFFD35400);
    const secondaryOrange = Color(0xFFE67E22);
    const neutralBackground = Color(0xFF1A1614);
    const creamText = Color(0xFFFDF5E6);

    return Scaffold(
      backgroundColor: neutralBackground,
      appBar: AppBar(
        backgroundColor: neutralBackground,
        elevation: 0,
        title: const Text('My Orders', style: TextStyle(fontWeight: FontWeight.bold, color: creamText)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: secondaryOrange),
            tooltip: 'Refresh Orders',
            onPressed: () {
              context.read<CustomerOrdersBloc>().add(LoadCustomerOrders(customerId));
            },
          ),
        ],
      ),
      body: BlocBuilder<CustomerOrdersBloc, CustomerOrdersState>(
        builder: (context, state) {
          if (state is CustomerOrdersLoading || state is CustomerOrdersInitial) {
            return const Center(child: CircularProgressIndicator(color: primaryOrange));
          }
          if (state is CustomerOrdersError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 64, color: Colors.redAccent),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: creamText),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryOrange,
                        foregroundColor: creamText,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        context.read<CustomerOrdersBloc>().add(LoadCustomerOrders(customerId));
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final orders = (state as CustomerOrdersLoaded).orders;
          if (orders.isEmpty) {
            return RefreshIndicator(
              color: primaryOrange,
              backgroundColor: const Color(0xFF241E1C),
              onRefresh: () async {
                context.read<CustomerOrdersBloc>().add(LoadCustomerOrders(customerId));
              },
              child: ListView(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long_outlined, size: 72, color: secondaryOrange.withValues(alpha: 0.6)),
                        const SizedBox(height: 16),
                        const Text(
                          'No orders placed yet',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: creamText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Order delicious meals from FoodieGo!',
                          style: TextStyle(color: creamText.withValues(alpha: 0.6)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: primaryOrange,
            backgroundColor: const Color(0xFF241E1C),
            onRefresh: () async {
              context.read<CustomerOrdersBloc>().add(LoadCustomerOrders(customerId));
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: OrderCard(
                    order: order,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => OrderDetailPage(orderId: order.orderId)),
                    ),
                    trailingAction: order.orderStatus == 'Delivered'
                        ? (!order.isRated
                            ? ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryOrange,
                                  foregroundColor: creamText,
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                icon: const Icon(Icons.star_rounded, size: 16),
                                label: const Text('Rate Rider', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RateRiderPage(
                                      orderId: order.orderId,
                                      riderId: order.riderId ?? '',
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: secondaryOrange.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: secondaryOrange.withValues(alpha: 0.3)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star_rounded, color: secondaryOrange, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Rated ${order.ratingStars?.toStringAsFixed(1) ?? '5.0'} ★',
                                      style: const TextStyle(color: creamText, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ))
                        : null,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
