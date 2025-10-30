import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/job_entity.dart';
import '../../domain/repositories/job_repository.dart';
import '../datasource/fire_job_datasource.dart';

class JobRepositoryImpl implements JobRepository {
  final FirebaseJobDataSource dataSource;

  JobRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, JobEntity>> addJob(JobEntity job) async {
    try {
      final addedJob = await dataSource.addJob(job);
      return Right(addedJob);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Lỗi Firestore: ${e.code}'));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: $e'));
    }
  }
}
