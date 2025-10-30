import 'package:dartz/dartz.dart';
import 'package:work_near/core/error/failures.dart';
import 'package:work_near/features/job/domain/entities/job_entity.dart';

abstract class JobRepository{
  Future<Either<Failure, JobEntity>> addJob(JobEntity job);
}