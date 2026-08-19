import 'package:flutter/material.dart';
import 'package:restaurant_app/features/cart/domain/entities/cart_item_entity.dart';

class PaymentSummaryCard extends StatelessWidget {
  final List<CartItemEntity> items;
  final double total;

  const PaymentSummaryCard({super.key, required this.items, required this.total});

  @override
  Widget build(BuildContext context) {
    const secondaryOrange = Color(0xFFE67E22);
    const darkSurface = Color(0xFF241E1C);
    const creamText = Color(0xFFFDF5E6);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: darkSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.receipt_rounded, color: secondaryOrange, size: 20),
              SizedBox(width: 8),
              Text('Order Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: creamText)),
            ],
          ),
          const Divider(height: 20, color: Colors.white12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${item.name} × ${item.quantity}',
                      style: TextStyle(color: creamText.withValues(alpha: 0.85), fontSize: 14),
                    ),
                    Text(
                      '\$${item.subtotal.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.w500, color: creamText, fontSize: 14),
                    ),
                  ],
                ),
              )),
          const Divider(height: 20, color: Colors.white12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Items Subtotal', style: TextStyle(fontWeight: FontWeight.bold, color: creamText, fontSize: 15)),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: secondaryOrange, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
