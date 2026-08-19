import 'package:flutter/material.dart';
import 'package:restaurant_app/features/menu/domain/entities/menu_item_entity.dart';

class MenuItemCard extends StatelessWidget {
  final MenuItemEntity item;
  final VoidCallback onTap;

  const MenuItemCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const primaryOrange = Color(0xFFD35400);
    const secondaryOrange = Color(0xFFE67E22);
    const darkCardBg = Color(0xFF241E1C);
    const creamText = Color(0xFFFDF5E6);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: darkCardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                // Food Image Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: item.imageUrl.isNotEmpty
                      ? Image.network(
                          item.imageUrl,
                          width: 82,
                          height: 82,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 82,
                            height: 82,
                            color: primaryOrange.withValues(alpha: 0.2),
                            child: const Icon(Icons.fastfood, color: secondaryOrange, size: 36),
                          ),
                        )
                      : Container(
                          width: 82,
                          height: 82,
                          color: primaryOrange.withValues(alpha: 0.2),
                          child: const Icon(Icons.fastfood, color: secondaryOrange, size: 36),
                        ),
                ),
                const SizedBox(width: 14),

                // Item Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: creamText,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description.isNotEmpty ? item.description : 'Delicious prepared meal',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: creamText.withValues(alpha: 0.65),
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Price Tag Pill Box matching reference screenshot
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF382319),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: secondaryOrange.withValues(alpha: 0.4),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: secondaryOrange,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Chevron Right Icon
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white.withValues(alpha: 0.4),
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
