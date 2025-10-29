class UserProfileEntity {
  final String uid;
  final String email;
  final String? name;
  final String? phone;
  final String? avatarUrl;
  final List<String>? skills;

  const UserProfileEntity({
    required this.uid,
    required this.email,
    this.name,
    this.phone,
    this.avatarUrl,
    this.skills,
  });


}