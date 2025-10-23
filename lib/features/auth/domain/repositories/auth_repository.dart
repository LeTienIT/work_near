import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> loginWithEmailPassword({required String email, required String password,});

  Future<Either<Failure, UserEntity>> register(String email, String password);

  Future<Either<Failure, void>> logout();
}