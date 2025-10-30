import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/job_add.dart';
import 'job_event.dart';
import 'job_state.dart';

class JobBloc extends Bloc<JobEvent, JobState> {
  final JobAdd addJobUseCase;

  JobBloc(this.addJobUseCase) : super(JobInitial()) {
    on<AddJobEvent>(_onAddJob);
  }

  Future<void> _onAddJob(AddJobEvent event, Emitter<JobState> emit) async {
    emit(JobLoading());
    final result = await addJobUseCase(event.job);
    result.fold(
          (failure) => emit(JobError(failure.message)),
          (job) => emit(JobAddedSuccess(job)),
    );
  }
}
