import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/menu/domain/entities/menu_item_entity.dart';
import 'package:restaurant_app/features/menu/domain/repositories/menu_repository.dart';

/// Admin-only. Permission enforcement itself belongs to Firestore rules,
/// not this class — this just represents the intent.
class AddMenuItemUseCase implements UseCase<void, MenuItemEntity> {
  final MenuRepository repository;
  AddMenuItemUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(MenuItemEntity params) {
    return repository.addMenuItem(params);
  }
}
