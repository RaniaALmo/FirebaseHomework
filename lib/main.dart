import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_homework/helpers/fcm_helpers.dart';
import 'package:firebase_homework/firebase_options.dart';
import 'package:firebase_homework/helpers/local_notifications_helpers.dart';
import 'package:firebase_homework/viewmodels/notes/note_vm.dart';
import 'package:firebase_homework/viewmodels/projects/projects_vm.dart';
import 'package:firebase_homework/viewmodels/tasks/task_vm.dart';
import 'package:firebase_homework/views/screens/add_new_project_screen.dart';
import 'package:firebase_homework/views/screens/add_new_task_screen.dart';
import 'package:firebase_homework/views/screens/note_screen.dart';
import 'package:firebase_homework/views/screens/test_local_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_homework/theme/app_theme.dart';
import 'package:firebase_homework/views/screens/edit_task_screen.dart';
import 'package:firebase_homework/views/screens/home_screen.dart';
import 'package:firebase_homework/views/screens/login_screen.dart';
import 'package:firebase_homework/views/screens/project_details_screen.dart';
import 'package:firebase_homework/views/screens/registration_screen.dart';
import 'package:firebase_homework/views/screens/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'models/project.dart';


Future<void> fcmBackgroundListener(RemoteMessage message) async {
}

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options : DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(fcmBackgroundListener);
  LocalNotificationsHelper localNotificationsHelper = LocalNotificationsHelper();
  localNotificationsHelper.initLocalNotification();

  FCMHelpers fcm = FCMHelpers() ..initFCM();
  //FCMHelpers helper = FCMHelpers();
  //helper.initFCM();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProjectVm()),
        BlocProvider(create: (_) => NotesVM()),
        BlocProvider(create: (_) => TaskVm()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return

      MaterialApp(
      title: 'TaskFlow',
      theme: AppTheme.lightTheme,
      initialRoute: '/home',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const HomeScreen(),
        '/splash': (_) => const SplashScreen(),
        '/note': (_) => NoteScreen(),
        '/project_details': (context) {
          final project = ModalRoute.of(context)!.settings.arguments as Project;
          return ProjectDetailsScreen(project: project);
        },
        '/addTask': (context) {
          final projectId = ModalRoute.of(context)!.settings.arguments as String;
          return AddNewTaskScreen(projectId: projectId);
        },
        '/addProject': (_) => const AddNewProjectScreen(),
        '/local': (_) => const TestLocalScreen(),
      },
    );
  }
}
