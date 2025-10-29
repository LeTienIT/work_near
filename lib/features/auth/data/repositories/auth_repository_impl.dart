import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, UserEntity>> loginWithEmailPassword({required String email, required String password,}) async {
    try {
      final user = await dataSource.loginWithEmailPassword(email, password);
      return Right(user);
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return Left(AuthFailure('Email không hợp lệ.'));
      } else if (e.code == 'user-not-found') {
        return Left(AuthFailure('Tài khoản không tồn tại.'));
      } else if (e.code == 'wrong-password') {
        return Left(AuthFailure('Sai mật khẩu.'));
      } else {
        return Left(AuthFailure('Đăng nhập thất bại. Vui lòng thử lại.'));
      }
    }catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(String email, String password) async {
    try {
      final user = await dataSource.registerWithEmailPassword(email, password);
      return Right(user);
    } on fb.FirebaseAuthException catch (e) {
      return Left(RegisterFailure(e.message ?? 'Register error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await dataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
