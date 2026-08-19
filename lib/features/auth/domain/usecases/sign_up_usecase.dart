import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/auth/domain/entities/user_entity.dart';
import 'package:restaurant_app/features/auth/domain/repositories/auth_repository.dart';

class SignUpParams extends Equatable {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String role;

  const SignUpParams({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.role,
  });

  @override
  List<Object?> get props => [name, email, password, phone, role];
}

class SignUpUseCase implements UseCase<UserEntity, SignUpParams> {
  final AuthRepository repository;
  SignUpUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignUpParams params) {
    if (params.password.length < 6) {
      return Future.value(
        const Left(ValidationFailure('Password must be at least 6 characters.')),
      );
    }
    return repository.signUp(
      name: params.name,
      email: params.email,
      password: params.password,
      phone: params.phone,
      role: params.role,
    );
  }
}
