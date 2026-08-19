import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/errors/exceptions.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:restaurant_app/features/cart/data/models/cart_item_model.dart';
import 'package:restaurant_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:restaurant_app/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;
  CartRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<CartItemEntity>>> getCart() async {
    try {
      return Right(await localDataSource.getCart());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addItem(CartItemEntity item) async {
    try {
      final current = await localDataSource.getCart();
      final existingIndex = current.indexWhere((e) => e.itemId == item.itemId);
      if (existingIndex >= 0) {
        current[existingIndex] = CartItemModel.fromEntity(
          current[existingIndex].copyWith(
            quantity: current[existingIndex].quantity + item.quantity,
          ),
        );
      } else {
        current.add(CartItemModel.fromEntity(item));
      }
      await localDataSource.saveCart(current);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeItem(String itemId) async {
    try {
      final current = await localDataSource.getCart();
      current.removeWhere((e) => e.itemId == itemId);
      await localDataSource.saveCart(current);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateQuantity(String itemId, int quantity) async {
    try {
      final current = await localDataSource.getCart();
      final index = current.indexWhere((e) => e.itemId == itemId);
      if (index >= 0) {
        current[index] = CartItemModel.fromEntity(current[index].copyWith(quantity: quantity));
        await localDataSource.saveCart(current);
      }
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await localDataSource.clearCart();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
