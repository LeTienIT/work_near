import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_near/features/profile/domain/entities/user_profile_entity.dart';

class FirebaseStoreDataSource{
  final FirebaseFirestore firestore;

  FirebaseStoreDataSource(this.firestore);

  Future<UserProfileEntity> getProfile(String uid, String email) async{
    final docRef = firestore.collection('users').doc(uid);
    final doc = await docRef.get();

    if(!doc.exists){
      final defaulData = {
        'uid' : uid,
        'email': email,
        'name': '',
        'phone': '',
        'avatarUrl': '',
        'skills': [],
        'createAt': FieldValue.serverTimestamp()
      };
      await docRef.set(defaulData);
      return UserProfileEntity(
          uid: uid, 
          email: email,
          name: '',
          phone: '',
          avatarUrl: '',
          skills: [],
      );
    }
    final data = doc.data()!;
    return UserProfileEntity(
      uid: data['uid'] ?? uid,
      email: data['email'] ?? email,
      name: data['name'],
      phone: data['phone'],
      avatarUrl: data['avatarUrl'],
      skills: data['skills'] != null ? List<String>.from(data['skills']) : [],
    );
  }
}