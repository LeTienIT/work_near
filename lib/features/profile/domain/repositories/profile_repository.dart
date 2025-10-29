import 'package:dartz/dartz.dart';
import 'package:work_near/core/error/failures.dart';
import 'package:work_near/core/usecase/usecase.dart';
import 'package:work_near/features/profile/domain/entities/user_profile_entity.dart';

abstract class ProfileRepository{
  Future<Either<Failure, UserProfileEntity>> getProfile(GetProfileParams params);
}