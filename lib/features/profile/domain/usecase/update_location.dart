import 'package:dartz/dartz.dart';
import 'package:work_near/core/usecase/usecase.dart';
import 'package:work_near/features/profile/domain/entities/user_profile_entity.dart';
import 'package:work_near/features/profile/domain/repositories/profile_repository.dart';

import '../../../../core/error/failures.dart';

class UpdateLocation extends UseCase<bool, GetProfileParams>{
  ProfileRepository repository;

  UpdateLocation(this.repository);

  @override
  Future<Either<Failure, bool>> call(GetProfileParams params) {
    return repository.updateLocation(params);
  }
}