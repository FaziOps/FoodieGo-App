import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/core/constants/app_constants.dart';
import 'package:restaurant_app/core/di/injection_container.dart';
import 'package:restaurant_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:restaurant_app/features/navigation/domain/usecases/launch_navigation_usecase.dart';
import 'package:restaurant_app/features/orders/domain/entities/order_entity.dart';
import 'package:restaurant_app/features/orders/presentation/bloc/rider_orders_bloc.dart';
import 'package:restaurant_app/features/orders/presentation/widgets/order_card.dart';
import 'package:restaurant_app/features/rating/presentation/pages/rider_ratings_page.dart';
import 'package:restaurant_app/features/rider_management/domain/usecases/toggle_rider_online_status_usecase.dart';

class RiderDashboardPage extends StatefulWidget {
  const RiderDashboardPage({super.key});

  @override
  State<RiderDashboardPage> createState() => _RiderDashboardPageState();
}

class _RiderDashboardPageState extends State<RiderDashboardPage> {
  bool _isOnline = true;
  String _selectedFilter = 'Active';

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _isOnline = authState.user.isOnline;
    }
  }

  Future<void> _toggleOnlineStatus(String riderId, bool value) async {
    setState(() => _isOnline = value);
    final result = await sl<ToggleRiderOnlineStatusUseCase>().call(
      ToggleRiderOnlineStatusParams(riderId: riderId, isOnline: value),
    );
    result.fold(
      (failure) {
        setState(() => _isOnline = !value);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not change online status: ${failure.message}'),
              backgroundColor: const Color(0xFFD35400),
            ),
          );
        }
      },
      (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(value ? 'You are now ONLINE' : 'You are now OFFLINE'),
              duration: const Duration(seconds: 2),
              backgroundColor: value ? const Color(0xFF2ECC71) : Colors.grey[800],
            ),
          );
        }
      },
    );
  }

  IconData _getNextStatusIcon(String status) {
    switch (status) {
      case AppConstants.statusAccepted:
        return Icons.check_circle_outline;
      case AppConstants.statusPreparing:
        return Icons.soup_kitchen_outlined;
      case AppConstants.statusPickedUp:
      case AppConstants.statusOnTheWay:
        return Icons.two_wheeler;
      case AppConstants.statusDelivered:
        return Icons.task_alt;
      default:
        return Icons.arrow_forward;
    }
  }

  String _formatStatusLabel(String nextStatus) {
    if (nextStatus == AppConstants.statusOnTheWay) {
      return 'Out for Delivery';
    }
    return nextStatus;
  }

  List<OrderEntity> _filterOrders(List<OrderEntity> orders) {
    if (_selectedFilter == 'Active') {
      return orders.where((o) => o.isActive).toList();
    }
    if (_selectedFilter == 'Completed') {
      return orders.where((o) => o.orderStatus == AppConstants.statusDelivered).toList();
    }
    return orders;
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final riderUser = authState is AuthAuthenticated ? authState.user : null;
    final riderId = riderUser?.uid ?? '';
    final rating = riderUser?.averageRating ?? 5.0;

    const primaryOrange = Color(0xFFD35400);
    const secondaryOrange = Color(0xFFE67E22);
    const neutralBackground = Color(0xFF1A1614);
    const darkSurface = Color(0xFF241E1C);
    const creamText = Color(0xFFFDF5E6);

    return BlocProvider(
      create: (_) => sl<RiderOrdersBloc>()..add(LoadRiderOrders(riderId)),
      child: Scaffold(
        backgroundColor: neutralBackground,
        appBar: AppBar(
          backgroundColor: neutralBackground,
          elevation: 0,
          title: const Text('Rider Dashboard', style: TextStyle(color: creamText, fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              icon: const Icon(Icons.star_rounded, color: secondaryOrange),
              tooltip: 'Reviews & Rating',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RiderRatingsPage(riderId: riderId)),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              onPressed: () => context.read<AuthBloc>().add(const LogoutRequested()),
            ),
          ],
        ),
        body: Column(
          children: [
            // Status Header Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: darkSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Row(
                children: [
                  Icon(
                    _isOnline ? Icons.power_settings_new_rounded : Icons.power_off_rounded,
                    color: _isOnline ? const Color(0xFF2ECC71) : Colors.grey,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isOnline ? 'ONLINE — Ready for deliveries' : 'OFFLINE — Not accepting orders',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _isOnline ? const Color(0xFF2ECC71) : Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Rating: ${rating.toStringAsFixed(1)} ★',
                          style: TextStyle(fontSize: 12, color: creamText.withValues(alpha: 0.7)),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isOnline,
                    activeTrackColor: const Color(0xFF2ECC71),
                    activeThumbColor: creamText,
                    onChanged: (val) => _toggleOnlineStatus(riderId, val),
                  ),
                ],
              ),
            ),

            // Tab Filters (Active vs Completed vs All)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: ['Active', 'Completed', 'All'].map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      selectedColor: secondaryOrange,
                      backgroundColor: darkSurface,
                      labelStyle: TextStyle(
                        color: isSelected ? creamText : creamText.withValues(alpha: 0.7),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _selectedFilter = filter);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const Divider(height: 16, color: Colors.white12),

            Expanded(
              child: BlocBuilder<RiderOrdersBloc, RiderOrdersState>(
                builder: (context, state) {
                  if (state is RiderOrdersLoading || state is RiderOrdersInitial) {
                    return const Center(child: CircularProgressIndicator(color: primaryOrange));
                  }
                  if (state is RiderOrdersError) {
                    return Center(child: Text(state.message, style: const TextStyle(color: creamText)));
                  }
                  final allRiderOrders = (state as RiderOrdersLoaded).orders;
                  final orders = _filterOrders(allRiderOrders);

                  if (orders.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delivery_dining_rounded, size: 64, color: secondaryOrange.withValues(alpha: 0.6)),
                          const SizedBox(height: 12),
                          Text(
                            _isOnline
                                ? 'No ${_selectedFilter.toLowerCase()} deliveries found.'
                                : 'You are currently offline.\nTurn switch ON to receive orders.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: creamText.withValues(alpha: 0.7)),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final next = order.nextStatus;

                      return OrderCard(
                        order: order,
                        onTap: () {},
                        trailingAction: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.end,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            // Google Maps Navigation Button
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2980B9),
                                foregroundColor: creamText,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              icon: const Icon(Icons.navigation_rounded, size: 16),
                              label: const Text('Maps Nav', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              onPressed: () {
                                sl<LaunchNavigationUseCase>().call(
                                  LaunchNavigationParams(
                                    latitude: order.deliveryAddress.latitude,
                                    longitude: order.deliveryAddress.longitude,
                                  ),
                                );
                              },
                            ),

                            // Order Status Progression Button
                            if (next != null)
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: next == AppConstants.statusDelivered ? const Color(0xFF2ECC71) : primaryOrange,
                                  foregroundColor: creamText,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                icon: Icon(_getNextStatusIcon(next), size: 16),
                                label: Text(
                                  'Mark: ${_formatStatusLabel(next)}',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  context.read<RiderOrdersBloc>().add(
                                        AdvanceOrderStatusTapped(
                                          orderId: order.orderId,
                                          newStatus: next,
                                        ),
                                      );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Order #${order.orderId.substring(0, order.orderId.length.clamp(0, 6))} updated to $next!'),
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: primaryOrange,
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
