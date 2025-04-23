import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBlack,
      appBar: AppBar(
        backgroundColor: tdBlack,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: tdWhite),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                fontFamily: 'Lato',
                color: tdWhite,
              ),
            ),
            const SizedBox(height: 52),

            const Text('Username', style: TextStyle(color: tdWhite)),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter your Username',
                hintStyle: const TextStyle(color: tdGrey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: tdGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: tdPurple),
                ),
              ),
              style: const TextStyle(color: tdWhite),
            ),
            const SizedBox(height: 26),

            const Text('Password', style: TextStyle(color: tdWhite)),
            const SizedBox(height: 8),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: '●●●●●●●●●',
                hintStyle: const TextStyle(color: tdGrey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: tdGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: tdPurple),
                ),
              ),
              style: const TextStyle(color: tdWhite),
            ),
            const SizedBox(height: 70),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: tdPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(color: tdWhite),
                ),
              ),
            ),

            const SizedBox(height: 32),

            Row(
              children: [
                const Expanded(child: Divider(color: tdGrey2)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('or', style: TextStyle(color: tdGrey2)),
                ),
                const Expanded(child: Divider(color: tdGrey2)),
              ],
            ),
            const SizedBox(height: 40),

            OutlinedButton.icon(
              onPressed: () {},
              icon: SvgPicture.asset(
                'assets/icons/google.svg',
                width: 20,
                height: 20,
              ),
              label: const Text('Login with Google'),
              style: OutlinedButton.styleFrom(
                foregroundColor: tdWhite,
                side: BorderSide(color: tdPurple),
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),

            OutlinedButton.icon(
              onPressed: () {},
              icon: SvgPicture.asset(
                'assets/icons/apple.svg',
                width: 20,
                height: 20,
              ),
              label: const Text('Login with Apple'),
              style: OutlinedButton.styleFrom(
                foregroundColor: tdWhite,
                side: BorderSide(color: tdPurple),
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 46),

            Center(
              child: GestureDetector(
                // onTap: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) =>  RegisterScreen(),
                //     ),
                //   );
                // },
                child: Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    style: const TextStyle(color: tdWhite),
                    children: [
                      TextSpan(
                        text: 'Register',
                        style: TextStyle(
                          fontSize: 12,
                          color: tdWhite,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Lato',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
