import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_near/features/auth/domain/entities/user_entity.dart';
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
  final FirebaseAuth auth;

  AuthBloc({
    required this.loginUser,
    required this.logoutUser,
    required this.registerUser,
    required this.auth,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<RegisterRequested>(_onRegisterRequested);
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    Future.delayed(Duration(milliseconds: 50));
    auth.authStateChanges().listen((User? firebaseUser) {
      if (firebaseUser != null) {
        final userEntity = UserEntity.fromFirebaseUser(firebaseUser);
        emit(AuthAuthenticated(userEntity));
      }
    });
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
          (failure) => emit(RegisterError(_mapFailureToMessage(failure))),
          (user) => emit(RegisterSuccess()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    return failure.message;
  }
}
