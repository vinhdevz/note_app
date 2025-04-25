import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_todo_app/welcome/welcom_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBlack,
      body: Center(
<<<<<<< HEAD
        child: SvgPicture.asset(
          'assets/images/logo.svg',
          width: 150,
=======
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/logo2.svg', width: 150),
            SizedBox(height: 20),
            Text(
              'UpTodo',
              style: TextStyle(
                color: tdWhite,
                fontSize: 40,
                fontWeight: FontWeight.w700,
                fontFamily: 'Lato',
              ),
            ),
          ],
>>>>>>> 6c12871 (feat(register) : create register)
        ),
      ),
    );
  }
}
