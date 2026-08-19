part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthFailureState extends AuthState {
  final String message;
  const AuthFailureState(this.message);

  @override
  List<Object?> get props => [message];
}

/// Distinct from AuthFailureState so the UI can show a toast without
/// dumping the user back to an unauthenticated screen (e.g. after a
/// password reset request while already logged out).
class AuthActionSuccess extends AuthState {
  final String message;
  const AuthActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
