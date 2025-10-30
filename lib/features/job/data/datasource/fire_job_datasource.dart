import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_near/core/constant/constant.dart';
import '../../domain/entities/job_entity.dart';
import '../models/job_model.dart';

class FirebaseJobDataSource {
  final FirebaseFirestore firestore;

  FirebaseJobDataSource(this.firestore);

  Future<JobEntity> addJob(JobEntity job) async {
    final collection = firestore.collection(jobs);

    final model = JobModel.fromEntity(job);
    final docRef = await collection.add(model.toMap());

    await docRef.update({'jobId': docRef.id});
    final snapshot = await docRef.get();
    return JobModel.fromMap(snapshot.data()!);
  }
}
