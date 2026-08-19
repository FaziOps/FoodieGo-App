import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final String itemId;
  final String name;
  final int quantity;
  final double price;

  const OrderItemEntity({
    required this.itemId,
    required this.name,
    required this.quantity,
    required this.price,
  });

  @override
  List<Object?> get props => [itemId, name, quantity, price];
}
