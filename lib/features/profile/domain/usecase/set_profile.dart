import 'package:dartz/dartz.dart';
import 'package:work_near/features/profile/domain/entities/user_profile_entity.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/profile_repository.dart';

class SetProfile extends UseCase<bool, UserProfileEntity>{
  ProfileRepository repository;

  SetProfile(this.repository);

  @override
  Future<Either<Failure, bool>> call(UserProfileEntity params) {
    return repository.setProfile(params);
  }
}