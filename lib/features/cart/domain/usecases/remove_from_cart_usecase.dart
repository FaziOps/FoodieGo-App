import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/cart/domain/repositories/cart_repository.dart';

class RemoveFromCartParams extends Equatable {
  final String itemId;
  const RemoveFromCartParams(this.itemId);
  @override
  List<Object?> get props => [itemId];
}

class RemoveFromCartUseCase implements UseCase<void, RemoveFromCartParams> {
  final CartRepository repository;
  RemoveFromCartUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveFromCartParams params) {
    return repository.removeItem(params.itemId);
  }
}
