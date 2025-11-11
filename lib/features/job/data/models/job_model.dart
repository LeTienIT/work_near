import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_near/features/job/domain/entities/job_location_entity.dart';

import '../../domain/entities/job_entity.dart';


class JobModel extends JobEntity {
  const JobModel({
    super.jobId,
    required super.ownerId,
    required super.title,
    required super.description,
    super.price,
    super.location,
    required super.applicants,
    super.selectedFreelancerId,
    required super.status,
    required super.deadline,
    super.createdAt,
    super.updatedAt,
  });

  // ------------------------------
  // FROM MAP (Firestore → Model)
  // ------------------------------
  factory JobModel.fromMap(Map<String, dynamic> map) {
    return JobModel(
      jobId: map['jobId'],
      ownerId: map['ownerId'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] != null) ? (map['price'] as num).toDouble() : null,
      applicants: List<String>.from(map['applicants'] ?? []),
      selectedFreelancerId: map['selectedFreelancerId'],
      status: map['status'] ?? 'open',
      deadline: (map['deadline'] as Timestamp).toDate(),
      createdAt:
      map['createdAt'] != null ? (map['createdAt'] as Timestamp).toDate() : null,
      updatedAt:
      map['updatedAt'] != null ? (map['updatedAt'] as Timestamp).toDate() : null,

      // ✅ parse location
      location: map['location'] != null
          ? JobLocationEntity(
        name: map['location']['name'] ?? '',
        detail: map['location']['detail'],
        latitude: (map['location']['latitude'] as num).toDouble(),
        longitude: (map['location']['longitude'] as num).toDouble(),
      )
          : null,
    );
  }

  // ------------------------------
  // TO MAP (Model → Firestore)
  // ------------------------------
  Map<String, dynamic> toMap() {
    return {
      'jobId': jobId,
      'ownerId': ownerId,
      'title': title,
      'description': description,
      'price': price,
      'status': status,
      'deadline': Timestamp.fromDate(deadline),
      'applicants': applicants,
      'selectedFreelancerId': selectedFreelancerId,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),

      'location': location != null
          ? {
        'name': location!.name,
        'detail': location!.detail,
        'latitude': location!.latitude,
        'longitude': location!.longitude,
      }
          : null,
    };
  }

  // ------------------------------
  // FROM ENTITY (Domain → Data)
  // ------------------------------
  factory JobModel.fromEntity(JobEntity entity) {
    return JobModel(
      jobId: entity.jobId,
      ownerId: entity.ownerId,
      title: entity.title,
      description: entity.description,
      price: entity.price,
      location: entity.location,
      applicants: entity.applicants,
      selectedFreelancerId: entity.selectedFreelancerId,
      status: entity.status,
      deadline: entity.deadline,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

