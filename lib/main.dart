import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/database/user_db.dart';
import 'package:flutter_todo_app/home/home_screen.dart';
import 'package:flutter_todo_app/home/profile_screen.dart';
import 'package:flutter_todo_app/home/setting_screen.dart';
import 'package:flutter_todo_app/intro/intro_screen.dart';
import 'package:flutter_todo_app/login/login_screen.dart';
import 'package:flutter_todo_app/onboading/onboading_screen.dart';
import 'package:flutter_todo_app/welcome/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedData = await UserDatabase.instance.getSavedLogin();

  String initialRoute;
  if (savedData != null) {
    final isValid = await UserDatabase.instance.checkLogin(
      savedData['username']!,
      savedData['password']!,
    );
    initialRoute = isValid ? '/home' : '/login';
  } else {
    initialRoute = '/intro';
  }

  runApp(MyApp(initialRoute: initialRoute));
}


class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

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
      initialRoute: initialRoute,
      routes: {
        '/intro': (context) => const IntroScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/welcome': (context) => const StartScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => ProfileScreen(
              username: 'Dothanhvinh',
              onLogout: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (Route<dynamic> route) => false,
                );
              },
            ),
        '/settings': (context) => const SettingScreen(),
      },
    );
  }
}
