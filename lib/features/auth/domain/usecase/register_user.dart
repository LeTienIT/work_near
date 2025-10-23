import 'package:dartz/dartz.dart';
import 'package:work_near/features/auth/domain/entities/user_entity.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class RegisterUser extends UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;

  RegisterUser(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return repository.register(params.email, params.password);
  }
}