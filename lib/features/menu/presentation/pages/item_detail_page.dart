import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:restaurant_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:restaurant_app/features/menu/domain/entities/menu_item_entity.dart';

class ItemDetailPage extends StatefulWidget {
  final MenuItemEntity item;
  const ItemDetailPage({super.key, required this.item});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    const primaryOrange = Color(0xFFD35400);
    const secondaryOrange = Color(0xFFE67E22);
    const neutralBackground = Color(0xFF1A1614);
    const darkSurface = Color(0xFF241E1C);
    const creamText = Color(0xFFFDF5E6);

    final totalPrice = item.price * _quantity;

    return Scaffold(
      backgroundColor: neutralBackground,
      appBar: AppBar(
        backgroundColor: neutralBackground,
        elevation: 0,
        title: Text(item.name, style: const TextStyle(color: creamText, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Food Hero Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: item.imageUrl.isNotEmpty
                          ? Image.network(
                              item.imageUrl,
                              height: 240,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 240,
                                color: darkSurface,
                                child: const Icon(Icons.fastfood, size: 72, color: secondaryOrange),
                              ),
                            )
                          : Container(
                              height: 240,
                              width: double.infinity,
                              color: darkSurface,
                              child: const Icon(Icons.fastfood, size: 72, color: secondaryOrange),
                            ),
                    ),
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: creamText,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: secondaryOrange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    Text(
                      item.description.isNotEmpty
                          ? item.description
                          : 'Delicious, fresh ingredients prepared specifically for your order.',
                      style: TextStyle(
                        fontSize: 14,
                        color: creamText.withValues(alpha: 0.75),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Divider(color: Colors.white12),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Select Quantity',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: creamText),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: darkSurface,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () => setState(() => _quantity = (_quantity - 1).clamp(1, 99)),
                                icon: const Icon(Icons.remove),
                                color: secondaryOrange,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Text(
                                  '$_quantity',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: creamText,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => setState(() => _quantity++),
                                icon: const Icon(Icons.add),
                                color: secondaryOrange,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Add to Cart Bar
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: darkSurface,
                border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08), width: 1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: Container(
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
                    icon: const Icon(Icons.add_shopping_cart_rounded),
                    label: Text(
                      'Add to Cart • \$${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                    onPressed: () {
                      context.read<CartBloc>().add(AddToCartEvent(CartItemEntity(
                            itemId: item.id,
                            name: item.name,
                            price: item.price,
                            quantity: _quantity,
                          )));
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added $_quantity x ${item.name} to cart'),
                          backgroundColor: primaryOrange,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
