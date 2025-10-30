import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:get_it/get_it.dart';
import 'package:work_near/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:work_near/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:work_near/features/auth/domain/repositories/auth_repository.dart';
import 'package:work_near/features/auth/domain/usecase/login_user.dart';
import 'package:work_near/features/auth/domain/usecase/logout_user.dart';
import 'package:work_near/features/auth/domain/usecase/register_user.dart';
import 'package:work_near/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:work_near/features/profile/domain/usecase/set_profile.dart';

import '../../features/job/data/datasource/fire_job_datasource.dart';
import '../../features/job/data/repositories/job_repository_impl.dart';
import '../../features/job/domain/repositories/job_repository.dart';
import '../../features/job/domain/usecase/job_add.dart';
import '../../features/job/presentation/bloc/job_bloc.dart';
import '../../features/profile/data/datasource/firebase_store_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecase/get_profile.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';


final di = GetIt.instance;

void initDI(){
  di.registerLazySingleton<fb.FirebaseAuth>(()=>fb.FirebaseAuth.instance);
  di.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  // Bloc Auth
  di.registerLazySingleton<FirebaseAuthDataSource>(
          ()=>FirebaseAuthDataSource(di<fb.FirebaseAuth>())
  );
  di.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(di<FirebaseAuthDataSource>())
  );
  di.registerLazySingleton<LoginUser>(
      () => LoginUser(di<AuthRepository>())
  );
  di.registerLazySingleton<RegisterUser>(
      () => RegisterUser(di<AuthRepository>())
  );
  di.registerLazySingleton<LogoutUser>(
          () => LogoutUser(di<AuthRepository>())
  );
  di.registerLazySingleton<AuthBloc>(
      () => AuthBloc(
          loginUser: di<LoginUser>(),
          logoutUser: di<LogoutUser>(),
          registerUser: di<RegisterUser>(),
          auth: di<fb.FirebaseAuth>()
      )
  );

  //   BLOC PROFILE
  di.registerLazySingleton<FirebaseStoreDataSource>(
        () => FirebaseStoreDataSource(di<FirebaseFirestore>()),
  );
  di.registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(di<FirebaseStoreDataSource>()),
  );
  di.registerLazySingleton<GetProfile>(
        () => GetProfile(di<ProfileRepository>()),
  );
  di.registerLazySingleton<SetProfile>(
        () => SetProfile(di<ProfileRepository>()),
  );
  di.registerFactory<ProfileBloc>(
        () => ProfileBloc(
          di<GetProfile>(),
          di<SetProfile>()
        ),
  );

  //   BLOC JOB
  di.registerLazySingleton<FirebaseJobDataSource>(
        () => FirebaseJobDataSource(di<FirebaseFirestore>()),
  );
  di.registerLazySingleton<JobRepository>(
          () => JobRepositoryImpl(di<FirebaseJobDataSource>())
  );
  di.registerLazySingleton<JobAdd>(
          () => JobAdd(di<JobRepository>())
  );
  di.registerFactory<JobBloc>(
          () => JobBloc(
              di<JobAdd>()
          )
  );
}