import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_near/core/constant/constant.dart';
import 'package:work_near/core/usecase/usecase.dart';
import 'package:work_near/features/location/domain/usecases/get_current_location.dart';
import 'package:work_near/features/profile/domain/entities/user_profile_entity.dart';
import 'package:work_near/core/di/injector.dart';
import '../../../location/domain/entities/location_entity.dart';
import '../models/user_profile_model.dart';

class FirebaseStoreDataSource{
  final FirebaseFirestore firestore;

  FirebaseStoreDataSource(this.firestore);

  Future<UserProfileEntity> getProfile(GetProfileParams params) async{
    final docRef = firestore.collection(collectionUser).doc(params.uid);
    final doc = await docRef.get();

    if(!doc.exists){
      final getLocation = di<GetCurrentLocation>();
      final locationC = await getLocation();

      final defaultData = {
        'uid' : params.uid,
        'email': params.email,
        'name': '',
        'phone': '',
        'avatarUrl': '',
        'skills': [],
        'createAt': FieldValue.serverTimestamp(),
        'location': {
          'latitude': locationC.latitude,
          'longitude': locationC.longitude,
          'updatedAt': FieldValue.serverTimestamp(),
        },
      };
      await docRef.set(defaultData);
      return UserProfileEntity(
          uid: params.uid,
          email: params.email,
          name: '',
          phone: '',
          avatarUrl: '',
          skills: [],
          location: locationC
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
      location: data['location'] != null ? LocationEntity(
        latitude: (data['location']['latitude'] as num).toDouble(),
        longitude: (data['location']['longitude'] as num).toDouble(),
      ) : null,
    );
  }

  Future<void> setProfile(UserProfileEntity entity) async{
    final docRef =  firestore.collection(collectionUser).doc(entity.uid);
    final getLocation = di<GetCurrentLocation>();
    final locationC = await getLocation();

    final model = UserProfileModel(
      uid: entity.uid,
      email: entity.email,
      name: entity.name,
      phone: entity.phone,
      avatarUrl: entity.avatarUrl,
      skills: entity.skills,
      location: locationC
    );

    await docRef.set(model.toMap(), SetOptions(merge: true));
  }

  Future<void> updateUserLocation(GetProfileParams params) async {
    // 1. Lấy vị trí hiện tại
    final getLocation = di<GetCurrentLocation>();
    final locationC = await getLocation();

    // 2. Reference tới document user
    final docRef = firestore.collection(collectionUser).doc(params.uid);

    final doc = await docRef.get();

    if (!doc.exists) {
      final defaultData = {
        'uid': params.uid,
        'email': params.email,
        'name': '',
        'phone': '',
        'avatarUrl': '',
        'skills': [],
        'createAt': FieldValue.serverTimestamp(),
        'location': {
          'latitude': locationC.latitude,
          'longitude': locationC.longitude,
          'updatedAt': FieldValue.serverTimestamp(),
        },
      };
      await docRef.set(defaultData);
    } else {
      // Document đã tồn tại → chỉ update location
      await docRef.update({
        'location': {
          'latitude': locationC.latitude,
          'longitude': locationC.longitude,
          'updatedAt': FieldValue.serverTimestamp(),
        }
      });
    }
  }

}