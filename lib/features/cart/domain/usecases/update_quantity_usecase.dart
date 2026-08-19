import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/cart/domain/repositories/cart_repository.dart';

class UpdateQuantityParams extends Equatable {
  final String itemId;
  final int quantity;
  const UpdateQuantityParams({required this.itemId, required this.quantity});
  @override
  List<Object?> get props => [itemId, quantity];
}

class UpdateQuantityUseCase implements UseCase<void, UpdateQuantityParams> {
  final CartRepository repository;
  UpdateQuantityUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateQuantityParams params) {
    if (params.quantity <= 0) {
      return repository.removeItem(params.itemId);
    }
    return repository.updateQuantity(params.itemId, params.quantity);
  }
}
