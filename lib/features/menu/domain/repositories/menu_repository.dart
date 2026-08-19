import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/features/menu/domain/entities/category_entity.dart';
import 'package:restaurant_app/features/menu/domain/entities/menu_item_entity.dart';

abstract class MenuRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, List<MenuItemEntity>>> getMenuItems({String? categoryId});
  Future<Either<Failure, void>> addMenuItem(MenuItemEntity item);
  Future<Either<Failure, void>> updateMenuItem(MenuItemEntity item);
  Future<Either<Failure, void>> deleteMenuItem(String itemId);
}
