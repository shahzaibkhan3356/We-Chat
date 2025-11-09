import 'package:chat_app/Bloc/AuthBloc/auth_bloc.dart';
import 'package:chat_app/Bloc/UserBloc/user_bloc.dart';
import 'package:chat_app/Repository/AuthRepository/AuthRepository.dart';
import 'package:chat_app/Repository/FirestoreRepository/FirestoreRepo.dart';
import 'package:chat_app/Routes/AppRoutes/Approutes.dart';
import 'package:chat_app/Routes/route_names/routenames.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FocusManager.instance.primaryFocus?.unfocus();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Supabase.initialize(
    debug: true,
    url: 'https://eoatkdaumustrrvvufpj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVvYXRrZGF1bXVzdHJydnZ1ZnBqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIwODE0NTYsImV4cCI6MjA3NzY1NzQ1Nn0.WlrvLB-Ym1c5ay165JRZFCnBoJb7LlFudl9qz1E_DNw',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(AuthRepo())),
        BlocProvider(create: (context) => UserBloc(FirestoreRepo())),
      ],
      child: GetMaterialApp(
        initialRoute: RouteNames.splash,
        getPages: AppPages.routes,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        theme: ThemeData(brightness: Brightness.dark),
      ),
    );
  }
}
