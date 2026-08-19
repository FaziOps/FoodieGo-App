part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class LoadCartEvent extends CartEvent {
  const LoadCartEvent();
}

class AddToCartEvent extends CartEvent {
  final CartItemEntity item;
  const AddToCartEvent(this.item);
  @override
  List<Object?> get props => [item];
}

class RemoveFromCartEvent extends CartEvent {
  final String itemId;
  const RemoveFromCartEvent(this.itemId);
  @override
  List<Object?> get props => [itemId];
}

class UpdateQuantityEvent extends CartEvent {
  final String itemId;
  final int quantity;
  const UpdateQuantityEvent({required this.itemId, required this.quantity});
  @override
  List<Object?> get props => [itemId, quantity];
}

class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}
