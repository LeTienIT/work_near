import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_near/core/di/injector.dart' as sl;
import 'package:work_near/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:work_near/features/auth/presentation/screens/login_screen.dart';
import 'package:work_near/features/auth/presentation/screens/register_screen.dart';
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
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng dụng',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: LoginScreen(),
    );
  }
}


