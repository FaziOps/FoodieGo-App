import 'package:restaurant_app/features/orders/domain/entities/order_item_entity.dart';

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required super.itemId,
    required super.name,
    required super.quantity,
    required super.price,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> map) => OrderItemModel(
        itemId: map['itemId'] as String,
        name: map['name'] as String,
        quantity: map['quantity'] as int,
        price: (map['price'] as num).toDouble(),
      );

  Map<String, dynamic> toMap() =>
      {'itemId': itemId, 'name': name, 'quantity': quantity, 'price': price};
}
