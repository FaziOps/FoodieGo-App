import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/core/constants/app_constants.dart';
import 'package:restaurant_app/core/di/injection_container.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:restaurant_app/features/menu/presentation/pages/admin_menu_editor_page.dart';
import 'package:restaurant_app/features/orders/domain/entities/order_entity.dart';
import 'package:restaurant_app/features/orders/presentation/bloc/admin_orders_bloc.dart';
import 'package:restaurant_app/features/orders/presentation/widgets/assign_rider_dialog.dart';
import 'package:restaurant_app/features/orders/presentation/widgets/order_card.dart';
import 'package:restaurant_app/features/rider_management/domain/usecases/get_available_riders_usecase.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  String _selectedFilter = 'All';

  Future<void> _openAssignDialog(BuildContext context, String orderId) async {
    final ridersResult = await sl<GetAvailableRidersUseCase>().call(const NoParams());
    ridersResult.fold(
      (failure) => ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(failure.message), backgroundColor: const Color(0xFFD35400))),
      (riders) async {
        if (riders.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No riders are currently ONLINE. Please ask a rider to toggle Online status.'),
              backgroundColor: Color(0xFFD35400),
            ),
          );
          return;
        }
        final riderId = await showDialog<String>(
          context: context,
          builder: (_) => AssignRiderDialog(riders: riders),
        );
        if (riderId != null && context.mounted) {
          context.read<AdminOrdersBloc>().add(
                AssignRiderTapped(orderId: orderId, riderId: riderId),
              );
        }
      },
    );
  }

  List<OrderEntity> _filterOrders(List<OrderEntity> orders) {
    if (_selectedFilter == 'All') return orders;
    return orders.where((o) => o.orderStatus == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    const primaryOrange = Color(0xFFD35400);
    const secondaryOrange = Color(0xFFE67E22);
    const neutralBackground = Color(0xFF1A1614);
    const darkSurface = Color(0xFF241E1C);
    const creamText = Color(0xFFFDF5E6);

    return BlocProvider(
      create: (_) => sl<AdminOrdersBloc>()..add(const LoadAllOrders()),
      child: Scaffold(
        backgroundColor: neutralBackground,
        appBar: AppBar(
          backgroundColor: neutralBackground,
          elevation: 0,
          title: const Text('Admin Dashboard', style: TextStyle(fontWeight: FontWeight.bold, color: creamText)),
          actions: [
            IconButton(
              icon: const Icon(Icons.restaurant_menu_rounded, color: secondaryOrange),
              tooltip: 'Manage Menu',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminMenuEditorPage()),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              onPressed: () => context.read<AuthBloc>().add(const LogoutRequested()),
            ),
          ],
        ),
        body: BlocBuilder<AdminOrdersBloc, AdminOrdersState>(
          builder: (context, state) {
            if (state is AdminOrdersLoading || state is AdminOrdersInitial) {
              return const Center(child: CircularProgressIndicator(color: primaryOrange));
            }
            if (state is AdminOrdersError) {
              return Center(child: Text(state.message, style: const TextStyle(color: creamText)));
            }
            final allOrders = (state as AdminOrdersLoaded).orders;
            final filteredOrders = _filterOrders(allOrders);

            final pendingCount = allOrders.where((o) => o.orderStatus == AppConstants.statusPlaced).length;
            final activeCount = allOrders.where((o) => o.isActive).length;

            return Column(
              children: [
                // Quick Summary Stats Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: darkSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('Total Orders', '${allOrders.length}', creamText),
                      _buildStatItem('Pending Accept', '$pendingCount', secondaryOrange),
                      _buildStatItem('Active In-Flight', '$activeCount', const Color(0xFF3498DB)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Status Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      'All',
                      AppConstants.statusPlaced,
                      AppConstants.statusAccepted,
                      AppConstants.statusPreparing,
                      AppConstants.statusPickedUp,
                      AppConstants.statusOnTheWay,
                      AppConstants.statusDelivered,
                    ].map((status) {
                      final isSelected = _selectedFilter == status;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(status),
                          selected: isSelected,
                          selectedColor: secondaryOrange,
                          backgroundColor: darkSurface,
                          labelStyle: TextStyle(
                            color: isSelected ? creamText : creamText.withValues(alpha: 0.7),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedFilter = status);
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const Divider(height: 24, color: Colors.white12),

                Expanded(
                  child: filteredOrders.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inbox_outlined, size: 64, color: secondaryOrange.withValues(alpha: 0.6)),
                              const SizedBox(height: 12),
                              Text(
                                _selectedFilter == 'All'
                                    ? 'No orders in system yet.'
                                    : 'No orders with status "$_selectedFilter".',
                                style: TextStyle(color: creamText.withValues(alpha: 0.7)),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredOrders.length,
                          itemBuilder: (context, index) {
                            final order = filteredOrders[index];
                            Widget? action;
                            if (order.orderStatus == AppConstants.statusPlaced) {
                              action = ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2ECC71),
                                  foregroundColor: creamText,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                icon: const Icon(Icons.check, size: 16),
                                label: const Text('Accept'),
                                onPressed: () => context
                                    .read<AdminOrdersBloc>()
                                    .add(AcceptOrderTapped(order.orderId)),
                              );
                            } else if (order.orderStatus == AppConstants.statusAccepted) {
                              action = ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryOrange,
                                  foregroundColor: creamText,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                icon: const Icon(Icons.person_add, size: 16),
                                label: const Text('Assign Rider'),
                                onPressed: () => _openAssignDialog(context, order.orderId),
                              );
                            }
                            return OrderCard(
                              order: order,
                              onTap: () {},
                              trailingAction: action,
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 2),
        Text(title, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.6))),
      ],
    );
  }
}
