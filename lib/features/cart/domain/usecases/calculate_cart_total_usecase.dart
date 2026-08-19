import 'package:restaurant_app/features/cart/domain/entities/cart_item_entity.dart';

/// Pure calculation — no repository call needed, so it does not implement
/// UseCase<Type, Params>. Kept as its own class anyway so the rule "cart
/// total math lives in exactly one place" is enforced by the type system,
/// not by convention.
class CalculateCartTotalUseCase {
  double call(List<CartItemEntity> items) {
    return items.fold(0.0, (sum, item) => sum + item.subtotal);
  }
}
