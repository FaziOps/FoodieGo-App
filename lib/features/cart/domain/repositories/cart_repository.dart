import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/features/cart/domain/entities/cart_item_entity.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItemEntity>>> getCart();
  Future<Either<Failure, void>> addItem(CartItemEntity item);
  Future<Either<Failure, void>> removeItem(String itemId);
  Future<Either<Failure, void>> updateQuantity(String itemId, int quantity);
  Future<Either<Failure, void>> clearCart();
}
