import '../../../location/domain/entities/location_entity.dart';

class UserProfileEntity {
  final String uid;
  final String email;
  final String? name;
  final String? phone;
  final String? avatarUrl;
  final List<String>? skills;
  final LocationEntity? location;

  const UserProfileEntity({
    required this.uid,
    required this.email,
    this.name,
    this.phone,
    this.avatarUrl,
    this.skills,
    this.location,
  });


}