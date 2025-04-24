import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constants/color.dart';

import '../login/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBlack,
      appBar: AppBar(
        backgroundColor: tdBlack,
        elevation: 0,
        leading: IconButton(
<<<<<<< HEAD
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
=======
          icon: const Icon(Icons.arrow_back_ios, color: tdWhite),
>>>>>>> 6c12871 (feat(register) : create register)
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40), 
            const Text(
              'Welcome to UpTodo',
              style: TextStyle(
<<<<<<< HEAD
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
=======
                color: tdWhite,
                fontSize: 32,
                fontWeight: FontWeight.w700,
                fontFamily: 'Lato',
>>>>>>> 6c12871 (feat(register) : create register)
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Please login to your account or create new account to continue.',
              style: TextStyle(
                color: tdGrey,
                fontSize: 16,
<<<<<<< HEAD
=======
                fontWeight: FontWeight.w400,
                fontFamily: 'Lato',
>>>>>>> 6c12871 (feat(register) : create register)
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(), 
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()
                  ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: tdPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'LOGIN',
                  style: TextStyle(
                    color: tdWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
<<<<<<< HEAD
=======
                    fontFamily: 'Lato',
>>>>>>> 6c12871 (feat(register) : create register)
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: tdDarkpurple, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'CREATE ACCOUNT',
                  style: TextStyle(
                    color: tdWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
