import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/auth/domain/entities/user_entity.dart';
import 'package:restaurant_app/features/auth/domain/repositories/auth_repository.dart';

class UpdateProfilePicParams extends Equatable {
  final String uid;
  final String imagePath;

  const UpdateProfilePicParams({required this.uid, required this.imagePath});

  @override
  List<Object?> get props => [uid, imagePath];
}

class UpdateProfilePicUseCase implements UseCase<UserEntity, UpdateProfilePicParams> {
  final AuthRepository repository;

  UpdateProfilePicUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateProfilePicParams params) {
    return repository.updateProfilePic(uid: params.uid, imagePath: params.imagePath);
  }
}
