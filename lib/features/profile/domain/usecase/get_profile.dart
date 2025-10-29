import 'package:dartz/dartz.dart';
import 'package:work_near/core/usecase/usecase.dart';
import 'package:work_near/features/profile/domain/entities/user_profile_entity.dart';
import 'package:work_near/features/profile/domain/repositories/profile_repository.dart';

import '../../../../core/error/failures.dart';

class GetProfile extends UseCase<UserProfileEntity, String>{
  ProfileRepository repository;

  GetProfile(this.repository);

  @override
  Future<Either<Failure, UserProfileEntity>> call(String params) {
    return repository.getProfile(params);
  }
}