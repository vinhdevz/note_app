import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/home/home_screen.dart';
import 'package:flutter_todo_app/intro/intro_screen.dart'; 
import 'package:flutter_todo_app/login/login_screen.dart';
import 'package:flutter_todo_app/onboading/onboading_screen.dart';
import 'package:flutter_todo_app/welcome/welcome_screen.dart'; 

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Lato',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/intro', 
      routes: {
        '/intro': (context) => const IntroScreen(),      
        '/onboarding': (context) => const OnboardingScreen(), 
        '/welcome': (context) => const StartScreen(),   
        '/login': (context) => const LoginScreen(),       
        '/home': (context) => const HomeScreen(),       
      },
    );
  }
}