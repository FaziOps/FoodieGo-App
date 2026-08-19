import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:restaurant_app/features/cart/domain/repositories/cart_repository.dart';

class AddToCartUseCase implements UseCase<void, CartItemEntity> {
  final CartRepository repository;
  AddToCartUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CartItemEntity params) {
    return repository.addItem(params);
  }
}
