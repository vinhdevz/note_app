import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_todo_app/database/user_db.dart';
import 'package:flutter_todo_app/register/register_screen.dart';
import 'package:flutter_todo_app/home/home_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBlack,
      appBar: AppBar(
        backgroundColor: tdBlack,
        elevation: 0,
        leading: const BackButtonCustom(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 40),
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
              TextFormField(
                controller: usernameController,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Username is required' : null,
                decoration: InputDecoration(
                  hintText: 'Enter your Username',
                  hintStyle: const TextStyle(color: tdGrey),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: tdGrey),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: tdPurple),
                  ),
                ),
                style: const TextStyle(color: tdWhite),
              ),
              const SizedBox(height: 26),
              const Text('Password', style: TextStyle(color: tdWhite)),
              const SizedBox(height: 8),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                validator: (value) =>
                    value == null || value.length < 6 ? 'Password must be at least 6 characters' : null,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: const TextStyle(color: tdGrey),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: tdGrey),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: tdPurple),
                  ),
                ),
                style: const TextStyle(color: tdWhite),
              ),
              CheckboxListTile(
                title: const Text(
                  'Ghi nhớ đăng nhập',
                  style: TextStyle(color: tdWhite),
                ),
                value: rememberMe,
                onChanged: (bool? value) {
                  setState(() {
                    rememberMe = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                activeColor: tdPurple,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      debugPrint('Username: ${usernameController.text}');
                      debugPrint('Password: ${passwordController.text}');

                      if (rememberMe) {
                        await UserDatabase.instance.insertUser(
                          usernameController.text,
                          passwordController.text,
                        );
                      } else {
                        await UserDatabase.instance.clearUser();
                      }
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => const Home()),
                      // );
                    }
                   
                    
                  
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tdPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Login', style: TextStyle(color: tdWhite)),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: const [
                  Expanded(child: Divider(color: tdGrey2)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('or', style: TextStyle(color: tdGrey2)),
                  ),
                  Expanded(child: Divider(color: tdGrey2)),
                ],
              ),
              const SizedBox(height: 40),
              OutlinedButton.icon(
                onPressed: () {},
                icon: SvgPicture.asset('assets/icons/google.svg', width: 20),
                label: const Text('Login with Google'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: tdWhite,
                  side: const BorderSide(color: tdPurple),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () {},
                icon: SvgPicture.asset('assets/icons/apple.svg', width: 20),
                label: const Text('Login with Apple'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: tdWhite,
                  side: const BorderSide(color: tdPurple),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 46),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: tdWhite),
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
      ),
    );
  }
}

class BackButtonCustom extends StatelessWidget {
  const BackButtonCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios, color: tdWhite),
      onPressed: () => Navigator.pop(context),
    );
  }
}
