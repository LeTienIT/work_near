import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_near/core/usecase/usecase.dart';
import 'package:work_near/features/profile/domain/entities/user_profile_entity.dart';

class FirebaseStoreDataSource{
  final FirebaseFirestore firestore;

  FirebaseStoreDataSource(this.firestore);

  Future<UserProfileEntity> getProfile(GetProfileParams params) async{
    final docRef = firestore.collection('users').doc(params.uid);
    final doc = await docRef.get();

    if(!doc.exists){
      final defaultData = {
        'uid' : params.uid,
        'email': params.email,
        'name': '',
        'phone': '',
        'avatarUrl': '',
        'skills': [],
        'createAt': FieldValue.serverTimestamp()
      };
      await docRef.set(defaultData);
      return UserProfileEntity(
          uid: params.uid,
          email: params.email,
          name: '',
          phone: '',
          avatarUrl: '',
          skills: [],
      );
    }
    final data = doc.data()!;
    return UserProfileEntity(
      uid: data['uid'] ?? params.uid,
      email: data['email'] ?? params.email,
      name: data['name'],
      phone: data['phone'],
      avatarUrl: data['avatarUrl'],
      skills: data['skills'] != null ? List<String>.from(data['skills']) : [],
    );
  }
}