import 'package:flutter/material.dart';
import 'package:restaurant_app/core/constants/app_constants.dart';

class OrderStatusStepper extends StatelessWidget {
  final String currentStatus;
  const OrderStatusStepper({super.key, required this.currentStatus});

  IconData _getIconForStatus(String status) {
    switch (status) {
      case AppConstants.statusPlaced:
        return Icons.receipt_long;
      case AppConstants.statusAccepted:
        return Icons.thumb_up_alt_outlined;
      case AppConstants.statusPreparing:
        return Icons.soup_kitchen_outlined;
      case AppConstants.statusPickedUp:
        return Icons.shopping_bag_outlined;
      case AppConstants.statusOnTheWay:
        return Icons.two_wheeler;
      case AppConstants.statusDelivered:
        return Icons.check_circle_outline;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryOrange = Color(0xFFD35400);
    const secondaryOrange = Color(0xFFE67E22);
    const creamText = Color(0xFFFDF5E6);

    const flow = AppConstants.orderStatusFlow;
    final currentIndex = flow.indexOf(currentStatus);

    return Column(
      children: List.generate(flow.length, (i) {
        final isReached = currentIndex >= 0 && i <= currentIndex;
        final isCurrent = i == currentIndex;
        final isLast = i == flow.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isReached
                          ? (isCurrent ? primaryOrange : secondaryOrange)
                          : Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      boxShadow: isCurrent
                          ? [
                              BoxShadow(
                                color: primaryOrange.withValues(alpha: 0.4),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      _getIconForStatus(flow[i]),
                      size: 20,
                      color: isReached ? creamText : Colors.grey[600],
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 3,
                        color: (currentIndex >= 0 && i < currentIndex)
                            ? secondaryOrange
                            : Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0, top: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flow[i],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isReached ? FontWeight.bold : FontWeight.normal,
                        color: isReached
                            ? (isCurrent ? secondaryOrange : creamText)
                            : Colors.grey[500],
                      ),
                    ),
                    if (isCurrent) ...[
                      const SizedBox(height: 2),
                      const Text(
                        'Current Status',
                        style: TextStyle(fontSize: 12, color: secondaryOrange, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
