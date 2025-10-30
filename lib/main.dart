import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:work_near/core/di/injector.dart' as sl;
import 'package:work_near/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:work_near/features/auth/presentation/bloc/auth_state.dart';
import 'package:work_near/features/auth/presentation/screens/login_screen.dart';
import 'package:work_near/features/auth/presentation/screens/register_screen.dart';
import 'package:work_near/features/home/presentation/screens/home_screen.dart';
import 'package:work_near/features/job/presentation/bloc/job_bloc.dart';
import 'package:work_near/features/job/presentation/screens/add_job_screen.dart';
import 'package:work_near/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:work_near/features/profile/presentation/screens/edit_profile_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  sl.initDI();

  runApp(
    BlocProvider(
      create: (_) => sl.di<AuthBloc>(),
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginScreen()
        ),
        GoRoute(
            path: '/register',
            builder: (context, state) => RegisterScreen()
        ),
        GoRoute(
            path: '/home',
            builder: (context, state) => HomeScreen()
        ),
        GoRoute(
            path: '/profile',
            builder: (context, state) => BlocProvider(
              create: (_)=> sl.di<ProfileBloc>(),
              child: const EditProfileScreen(),
            )
        ),
        GoRoute(
            path: '/add-job',
            builder: (context, state) => BlocProvider(
              create: (_)=> sl.di<JobBloc>(),
              child: const AddJobScreen(),
            )
        ),
      ],
    redirect: (context, state){
        final authBloc = sl.di<AuthBloc>();
        final currentState = authBloc.state;
        if(currentState is AuthLoading) return null;

        // Đã login -> nếu truy cập tiếp route login thì về luôn trang home
        if(currentState is AuthAuthenticated){
          if(state.matchedLocation == ""){

          }
          return null;
        }

        if(currentState is AuthError || currentState is AuthInitial){
          return null;
        }
    }
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Ứng dụng',
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}


