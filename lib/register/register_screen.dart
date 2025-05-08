import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_todo_app/database/user_db.dart';
import 'package:flutter_todo_app/login/login_screen.dart';
import 'dart:developer' as developer;

import 'package:flutter_todo_app/register/widgets/backButtonCustom.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _obs = true;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

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
              const SizedBox(height: 16),
              const Text(
                'Register',
                style: TextStyle(
                  color: tdWhite,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Lato',
                ),
              ),
              const SizedBox(height: 24),
              Text('Username', style: _labelStyle()),
              const SizedBox(height: 8),
              TextFormField(
                controller: usernameController,
                validator: (value) => value == null || value.isEmpty
                    ? 'Username is required'
                    : null,
                decoration: _inputDecoration('Enter your Username'),
                style: const TextStyle(color: tdWhite),
              ),
              const SizedBox(height: 26),
              Text('Password', style: _labelStyle()),
              const SizedBox(height: 8),
              TextFormField(
                controller: passwordController,
                obscureText: _obs,
                validator: (value) => value == null || value.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
                decoration: _inputDecoration('Password').copyWith(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obs = !_obs;
                      });
                    },
                    icon: Icon(
                      _obs ? Icons.visibility_off : Icons.visibility,
                      color: tdGrey,
                    ),
                  ),
                ),
                style: const TextStyle(color: tdWhite),
              ),
              const SizedBox(height: 26),
              Text('Confirm Password', style: _labelStyle()),
              const SizedBox(height: 8),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: _obs,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                decoration: _inputDecoration('Re-enter your password').copyWith(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obs = !_obs;
                      });
                    },
                    icon: Icon(
                      _obs ? Icons.visibility_off : Icons.visibility,
                      color: tdGrey,
                    ),
                  ),
                ),
                style: const TextStyle(color: tdWhite),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: tdPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Register', style: TextStyle(color: tdWhite)),
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
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () {},
                icon: SvgPicture.asset('assets/icons/google.svg', width: 20),
                label: const Text('Register with Google'),
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
              const SizedBox(height: 18),
              OutlinedButton.icon(
                onPressed: () {},
                icon: SvgPicture.asset('assets/icons/apple.svg', width: 20),
                label: const Text('Register with Apple'),
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
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: "Already have an account?  ",
                      style: TextStyle(color: tdWhite),
                      children: [
                        TextSpan(
                          text: 'Login',
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

  Future<void> _handleRegister() async {
    developer.log('Register button pressed');
    if (!_formKey.currentState!.validate()) {
      developer.log('Form validation failed');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix the errors in the form')),
      );
      return;
    }
    developer.log('Form validated');
    bool success = await UserDatabase.instance.insertUser(
      usernameController.text,
      passwordController.text,
    );
    developer.log('Insert user result: $success');
    if (success) {
      developer.log('Showing success SnackBar');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful')),
      );
      await Future.delayed(const Duration(seconds: 2));
      developer.log('Navigating to LoginScreen');
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } else {
      developer.log('Showing failure SnackBar');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username already exists')),
      );
    }
  }

  TextStyle _labelStyle() => const TextStyle(
        color: tdWhite,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontFamily: 'Lato',
      );

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: tdGrey2),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: tdGrey2)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: tdPurple)),
      );
}


