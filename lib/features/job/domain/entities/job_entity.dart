class JobEntity{
  final String? jobId;
  final String ownerId;
  final String title;
  final String description;
  final double? price;
  final String? location;
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