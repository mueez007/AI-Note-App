import 'package:ai_notes_app/firebase_options.dart';
import 'package:ai_notes_app/pages/auth_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  // Ensure Flutter and plugins are ready
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load the API key from the .env file
  await dotenv.load(fileName: ".env");

  // Initialize Firebase using the auto-generated options file
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.yellow,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.yellow,
          secondary: Colors.yellowAccent,
        ),
      ),
      // AuthWrapper will decide which screen to show
      home: const AuthWrapper(),
    );
  }
}