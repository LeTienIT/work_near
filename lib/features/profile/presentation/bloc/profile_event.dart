import 'package:work_near/core/usecase/usecase.dart';
import 'package:work_near/features/profile/domain/entities/user_profile_entity.dart';

abstract class ProfileEvent {
  const ProfileEvent();
}

class LoadUserProfile extends ProfileEvent {
  final GetProfileParams params;
  const LoadUserProfile(this.params);
}

class UpdateUserProfile extends ProfileEvent {
  final UserProfileEntity user;
  const UpdateUserProfile(this.user);
}