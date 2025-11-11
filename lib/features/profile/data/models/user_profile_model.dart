import '../../../location/domain/entities/location_entity.dart';
import '../../domain/entities/user_profile_entity.dart';

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.uid,
    required super.email,
    super.name,
    super.phone,
    super.avatarUrl,
    super.skills,
    super.location,
  });

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      phone: map['phone'],
      avatarUrl: map['avatarUrl'],
      skills: map['skills'] != null ? List<String>.from(map['skills']) : [],
      location: map['location'] != null ? LocationEntity(
        latitude: (map['location']['latitude'] as num).toDouble(),
        longitude: (map['location']['longitude'] as num).toDouble(),
      ) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'skills': skills ?? [],
      'location': location != null ? {
        'latitude': location!.latitude,
        'longitude': location!.longitude,
      }: null,
    };
  }
}