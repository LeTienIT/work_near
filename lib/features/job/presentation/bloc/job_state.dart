import '../../domain/entities/job_entity.dart';

abstract class JobState {
  const JobState();
}

class JobInitial extends JobState {}

class JobLoading extends JobState {}

class JobAddedSuccess extends JobState {
  final JobEntity job;
  const JobAddedSuccess(this.job);
}

class JobError extends JobState {
  final String message;
  const JobError(this.message);
}
