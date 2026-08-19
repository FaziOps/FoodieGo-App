import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:restaurant_app/features/cart/domain/repositories/cart_repository.dart';

class GetCartUseCase implements UseCase<List<CartItemEntity>, NoParams> {
  final CartRepository repository;
  GetCartUseCase(this.repository);

  @override
  Future<Either<Failure, List<CartItemEntity>>> call(NoParams params) {
    return repository.getCart();
  }
}
