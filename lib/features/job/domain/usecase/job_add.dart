import 'package:dartz/dartz.dart';
import 'package:work_near/core/error/failures.dart';
import 'package:work_near/core/usecase/usecase.dart';
import 'package:work_near/features/job/domain/entities/job_entity.dart';
import 'package:work_near/features/job/domain/repositories/job_repository.dart';

class JobAdd extends UseCase<JobEntity, JobEntity>{
  final JobRepository jobRepository;
  JobAdd(this.jobRepository);

  @override
  Future<Either<Failure, JobEntity>> call(JobEntity params) {
    return jobRepository.addJob(params);
  }

}