import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../domain/entities/user_entity.dart';

class FirebaseAuthDataSource {
  final fb.FirebaseAuth firebaseAuth;

  FirebaseAuthDataSource(this.firebaseAuth);

  Future<UserEntity> loginWithEmailPassword(String email, String password) async {
    final userCred = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCred.user!;
    return UserEntity(
      uid: user.uid,
      email: user.email!,
      emailVerified: user.emailVerified,
    );
  }

  Future<UserEntity> registerWithEmailPassword(String email, String password) async {
    try {
      final userCred = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCred.user!;

      return UserEntity(
        uid: user.uid,
        email: user.email!,
        emailVerified: user.emailVerified,
      );
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Register failed');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }

  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
}
