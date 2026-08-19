part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {
  const AppStarted();
}

class SignUpRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String role;

  const SignUpRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.role,
  });

  @override
  List<Object?> get props => [name, email, password, phone, role];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  const LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class PasswordResetRequested extends AuthEvent {
  final String email;
  const PasswordResetRequested(this.email);

  @override
  List<Object?> get props => [email];
}

class UpdateProfilePicRequested extends AuthEvent {
  final String uid;
  final String imagePath;
  const UpdateProfilePicRequested({required this.uid, required this.imagePath});

  @override
  List<Object?> get props => [uid, imagePath];
}
