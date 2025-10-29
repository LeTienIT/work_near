import 'package:work_near/features/profile/domain/entities/user_profile_entity.dart';

abstract class ProfileEvent {
  const ProfileEvent();
}

class LoadUserProfile extends ProfileEvent {
  final String uid;
  const LoadUserProfile(this.uid);
}

class UpdateUserProfile extends ProfileEvent {
  final UserProfileEntity user;
  const UpdateUserProfile(this.user);
}