import '../../domain/entities/job_entity.dart';

abstract class JobEvent {
  const JobEvent();
}

class AddJobEvent extends JobEvent {
  final JobEntity job;
  const AddJobEvent(this.job);
}
