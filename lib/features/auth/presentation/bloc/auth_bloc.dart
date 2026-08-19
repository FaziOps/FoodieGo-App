import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/core/usecase/usecase.dart';
import 'package:restaurant_app/features/auth/domain/entities/user_entity.dart';
import 'package:restaurant_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:restaurant_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:restaurant_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:restaurant_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:restaurant_app/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:restaurant_app/features/auth/domain/usecases/update_profile_pic_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// The ONLY class in the app allowed to hold auth UI state. Pages only
/// dispatch events and rebuild off state — no business logic in widgets.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase signUpUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final UpdateProfilePicUseCase updateProfilePicUseCase;

  AuthBloc({
    required this.signUpUseCase,
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.resetPasswordUseCase,
    required this.getCurrentUserUseCase,
    required this.updateProfilePicUseCase,
  }) : super(const AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<SignUpRequested>(_onSignUpRequested);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<PasswordResetRequested>(_onPasswordResetRequested);
    on<UpdateProfilePicRequested>(_onUpdateProfilePicRequested);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await getCurrentUserUseCase(const NoParams());
    result.fold(
      (failure) => emit(const AuthUnauthenticated()),
      (user) => emit(user != null ? AuthAuthenticated(user) : const AuthUnauthenticated()),
    );
  }

  Future<void> _onSignUpRequested(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await signUpUseCase(SignUpParams(
      name: event.name,
      email: event.email,
      password: event.password,
      phone: event.phone,
      role: event.role,
    ));
    result.fold(
      (failure) => emit(AuthFailureState(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthFailureState(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    await logoutUseCase(const NoParams());
    emit(const AuthUnauthenticated());
  }

  Future<void> _onPasswordResetRequested(
    PasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await resetPasswordUseCase(ResetPasswordParams(event.email));
    result.fold(
      (failure) => emit(AuthFailureState(failure.message)),
      (_) => emit(const AuthActionSuccess('Password reset email sent.')),
    );
  }

  Future<void> _onUpdateProfilePicRequested(
    UpdateProfilePicRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await updateProfilePicUseCase(UpdateProfilePicParams(
      uid: event.uid,
      imagePath: event.imagePath,
    ));

    result.fold(
      (failure) => emit(AuthFailureState(failure.message)),
      (updatedUser) => emit(AuthAuthenticated(updatedUser)),
    );
  }
}
