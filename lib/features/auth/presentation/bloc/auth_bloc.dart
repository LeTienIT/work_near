import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecase/login_user.dart';
import '../../domain/usecase/logout_user.dart';
import '../../domain/usecase/register_user.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../../../core/error/failures.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final LogoutUser logoutUser;
  final RegisterUser registerUser;

  AuthBloc({
    required this.loginUser,
    required this.logoutUser,
    required this.registerUser,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<RegisterRequested>(_onRegisterRequested);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUser(LoginParams(
      email: event.email,
      password: event.password,
    ));

    result.fold(
          (failure) => emit(AuthError(_mapFailureToMessage(failure))),
          (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await logoutUser(NoParams());

    result.fold(
          (failure) => emit(AuthError(_mapFailureToMessage(failure))),
          (_) => emit(AuthLoggedOut()),
    );
  }

  Future<void> _onRegisterRequested(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await registerUser(LoginParams(email: event.email, password: event.password,));
    result.fold(
          (failure) => emit(AuthError(_mapFailureToMessage(failure))),
          (user) => emit(AuthAuthenticated(user)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    return failure.message;
  }
}
