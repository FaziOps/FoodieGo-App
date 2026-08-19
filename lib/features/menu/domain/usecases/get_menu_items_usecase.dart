import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/menu/domain/entities/menu_item_entity.dart';
import 'package:restaurant_app/features/menu/domain/repositories/menu_repository.dart';

class GetMenuItemsParams extends Equatable {
  final String? categoryId;
  const GetMenuItemsParams({this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

class GetMenuItemsUseCase implements UseCase<List<MenuItemEntity>, GetMenuItemsParams> {
  final MenuRepository repository;
  GetMenuItemsUseCase(this.repository);

  @override
  Future<Either<Failure, List<MenuItemEntity>>> call(GetMenuItemsParams params) {
    return repository.getMenuItems(categoryId: params.categoryId);
  }
}
