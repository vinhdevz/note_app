import 'package:easy_localization/easy_localization.dart';
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
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('vi'),
      ],
      path: 'assets/langs',
      fallbackLocale: const Locale('en'),
      child: const AppInitializer(),
    ),
  );
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  String? _initialRoute;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    final savedData = await UserDatabase.instance.getSavedLogin();

    String route;
    if (savedData != null) {
      final isValid = await UserDatabase.instance.checkLogin(
        savedData['username']!,
        savedData['password']!,
      );
      route = isValid ? '/home' : '/login';
    } else {
      route = '/intro';
    }

    setState(() {
      _initialRoute = route;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_initialRoute == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MyApp(initialRoute: _initialRoute!);
  }
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
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: initialRoute,
      routes: {
        '/intro': (context) => const IntroScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/welcome': (context) => const StartScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(username: '',),
  
        '/profile': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          final username = args?['username'] as String? ?? 'User';
          final onLogout = args?['onLogout'] as VoidCallback? ?? () {};
          return ProfileScreen(
            username: username,
            onLogout: onLogout,
          );
        },
        '/settings': (context) => const SettingScreen(),
      },
    );
  }
}
