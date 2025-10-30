import 'package:cloud_firestore/cloud_firestore.dart' as fb;
import 'package:dartz/dartz.dart';
import 'package:work_near/core/error/failures.dart';
import 'package:work_near/features/profile/data/datasource/firebase_store_datasource.dart';
import 'package:work_near/features/profile/domain/entities/user_profile_entity.dart';
import 'package:work_near/features/profile/domain/repositories/profile_repository.dart';

import '../../../../core/usecase/usecase.dart';

class ProfileRepositoryImpl implements ProfileRepository{
  final FirebaseStoreDataSource fireStore;

  ProfileRepositoryImpl(this.fireStore);

  @override
  Future<Either<Failure, UserProfileEntity>> getProfile(GetProfileParams params) async {
    try{
      final user = await fireStore.getProfile(params);
      return Right(user);
    }on fb.FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        return Left(ServerFailure('Không có quyền truy cập dữ liệu.'));
      } else if (e.code == 'unavailable') {
        return Left(ServerFailure('Kết nối Firestore thất bại. Kiểm tra mạng.'));
      } else {
        return Left(ServerFailure('Lỗi Firestore: ${e.message ?? 'Không rõ nguyên nhân'}'));
      }
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> setProfile(UserProfileEntity entity) async {
    try{
      await fireStore.setProfile(entity);
      return Right(true);
    }catch(e){
      return left(ServerFailure(e.toString()));
    }
  }

}