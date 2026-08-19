import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String itemId;
  final String name;
  final double price;
  final int quantity;

  const CartItemEntity({
    required this.itemId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  double get subtotal => price * quantity;

  CartItemEntity copyWith({int? quantity}) => CartItemEntity(
        itemId: itemId,
        name: name,
        price: price,
        quantity: quantity ?? this.quantity,
      );

  @override
  List<Object?> get props => [itemId, name, price, quantity];
}
