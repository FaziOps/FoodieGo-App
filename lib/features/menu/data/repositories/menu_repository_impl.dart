import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/errors/exceptions.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/network/network_info.dart';
import 'package:restaurant_app/features/menu/data/datasources/menu_remote_data_source.dart';
import 'package:restaurant_app/features/menu/data/models/menu_item_model.dart';
import 'package:restaurant_app/features/menu/domain/entities/category_entity.dart';
import 'package:restaurant_app/features/menu/domain/entities/menu_item_entity.dart';
import 'package:restaurant_app/features/menu/domain/repositories/menu_repository.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  MenuRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      return Right(await remoteDataSource.getCategories());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<MenuItemEntity>>> getMenuItems({String? categoryId}) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      return Right(await remoteDataSource.getMenuItems(categoryId: categoryId));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addMenuItem(MenuItemEntity item) async {
    try {
      await remoteDataSource.addMenuItem(MenuItemModel.fromEntity(item));
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateMenuItem(MenuItemEntity item) async {
    try {
      await remoteDataSource.updateMenuItem(MenuItemModel.fromEntity(item));
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMenuItem(String itemId) async {
    try {
      await remoteDataSource.deleteMenuItem(itemId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
