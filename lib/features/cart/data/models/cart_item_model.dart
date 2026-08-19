import 'package:restaurant_app/features/cart/domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.itemId,
    required super.name,
    required super.price,
    required super.quantity,
  });

  factory CartItemModel.fromMap(Map<String, dynamic> map) => CartItemModel(
        itemId: map['itemId'] as String,
        name: map['name'] as String,
        price: (map['price'] as num).toDouble(),
        quantity: map['quantity'] as int,
      );

  Map<String, dynamic> toMap() => {
        'itemId': itemId,
        'name': name,
        'price': price,
        'quantity': quantity,
      };

  factory CartItemModel.fromEntity(CartItemEntity e) => CartItemModel(
        itemId: e.itemId,
        name: e.name,
        price: e.price,
        quantity: e.quantity,
      );
}
