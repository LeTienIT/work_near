import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserEntity extends Equatable {
  final String uid;
  final String email;
  final bool emailVerified;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.emailVerified,
  });

  factory UserEntity.fromFirebaseUser(User firebaseUser) {
    return UserEntity(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      emailVerified: firebaseUser.emailVerified,
    );
  }

  @override
  List<Object?> get props => [uid, email, emailVerified];
}