import 'package:flutter/material.dart';
import 'package:restaurant_app/core/constants/app_constants.dart';
import 'package:restaurant_app/features/orders/domain/entities/order_entity.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback onTap;
  final Widget? trailingAction;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
    this.trailingAction,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case AppConstants.statusPlaced:
        return const Color(0xFFE67E22);
      case AppConstants.statusAccepted:
        return Colors.blueAccent;
      case AppConstants.statusPreparing:
        return Colors.purpleAccent;
      case AppConstants.statusPickedUp:
      case AppConstants.statusOnTheWay:
        return Colors.indigoAccent;
      case AppConstants.statusDelivered:
        return const Color(0xFF2ECC71);
      case AppConstants.statusCancelled:
      case AppConstants.statusRejected:
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    const secondaryOrange = Color(0xFFE67E22);
    const darkSurface = Color(0xFF241E1C);
    const creamText = Color(0xFFFDF5E6);
    final statusColor = _getStatusColor(order.orderStatus);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row: Order ID & Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order #${order.orderId.substring(0, order.orderId.length.clamp(0, 6))}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: creamText,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        order.orderStatus,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Items Summary & Price
                Row(
                  children: [
                    Icon(Icons.shopping_bag_outlined, size: 16, color: creamText.withValues(alpha: 0.6)),
                    const SizedBox(width: 6),
                    Text(
                      '${order.items.length} item(s)',
                      style: TextStyle(color: creamText.withValues(alpha: 0.7), fontSize: 13),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '\$${order.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: secondaryOrange,
                      ),
                    ),
                  ],
                ),
                if (trailingAction != null) ...[
                  const SizedBox(height: 12),
                  trailingAction!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
