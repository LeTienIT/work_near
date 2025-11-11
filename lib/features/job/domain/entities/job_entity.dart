import 'package:work_near/features/job/domain/entities/job_location_entity.dart';

class JobEntity{
  final String? jobId;
  final String ownerId;
  final String title;
  final String description;
  final double? price;
  final JobLocationEntity? location;
  final List<String> applicants;
  final String? selectedFreelancerId;
  final String status;
  final DateTime deadline;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const JobEntity({
    this.jobId,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.deadline,
    this.price,
    this.location,
    this.applicants = const [],
    this.selectedFreelancerId,
    this.status = 'open',
    this.createdAt,
    this.updatedAt,
  });

}