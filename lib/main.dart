import 'package:chat_app/Bloc/AuthBloc/auth_bloc.dart';
import 'package:chat_app/Bloc/UserBloc/user_bloc.dart';
import 'package:chat_app/Presentation/Ui/Profile/ProfileSetup/SetupProfile.dart';
import 'package:chat_app/Repository/AuthRepository/AuthRepository.dart';
import 'package:chat_app/Repository/FirestoreRepository/FirestoreRepo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FocusManager.instance.primaryFocus?.unfocus();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
        BlocProvider(create: (context) => Userbloc(FirestoreRepo())),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        theme: ThemeData(brightness: Brightness.dark),
        home: ProfileSetupScreen(),
      ),
    );
  }
}
