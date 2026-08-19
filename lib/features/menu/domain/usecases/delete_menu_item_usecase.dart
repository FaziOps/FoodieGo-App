import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/menu/domain/repositories/menu_repository.dart';

class DeleteMenuItemParams extends Equatable {
  final String itemId;
  const DeleteMenuItemParams(this.itemId);
  @override
  List<Object?> get props => [itemId];
}

class DeleteMenuItemUseCase implements UseCase<void, DeleteMenuItemParams> {
  final MenuRepository repository;
  DeleteMenuItemUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteMenuItemParams params) {
    return repository.deleteMenuItem(params.itemId);
  }
}
