import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/errors/exceptions.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/network/network_info.dart';
import 'package:restaurant_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:restaurant_app/features/auth/domain/entities/user_entity.dart';
import 'package:restaurant_app/features/auth/domain/repositories/auth_repository.dart';

/// Only place in the whole app allowed to translate a raw exception into
/// a typed Failure. Domain and Presentation never do this themselves.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final user = await remoteDataSource.signUp(
        name: name,
        email: email,
        password: password,
        phone: phone,
        role: role,
      );
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final user = await remoteDataSource.login(email: email, password: password);
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } catch (_) {
      return const Left(ServerFailure('Could not log out.'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      await remoteDataSource.resetPassword(email);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } catch (_) {
      return const Left(ServerFailure('Failed to fetch session.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfilePic({
    required String uid,
    required String imagePath,
  }) async {
    try {
      final user = await remoteDataSource.updateProfilePic(uid: uid, imagePath: imagePath);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Could not update profile picture: $e'));
    }
  }
}
