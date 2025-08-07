import 'package:ai_notes_app/pages/home_page.dart';
import 'package:ai_notes_app/pages/login_signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the snapshot is still waiting, show a loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // If the user is logged in, show the HomePage
        if (snapshot.hasData) {
          return const HomePage();
        }
        // If the user is not logged in, show the LoginSignupPage
        else {
          return const LoginSignupPage();
        }
      },
    );
  }
}