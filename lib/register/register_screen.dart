import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final fullnameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _obsPass = true;
  bool _obsConfirm = true;

  @override
  void dispose() {
    fullnameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
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
    final result = await UserDatabase.instance.insertUser(
      usernameController.text,
      passwordController.text,
      fullnameController.text,
    );

    developer.log('Insert user result: $result');
    if (result == 'success') {
      await UserDatabase.instance.saveLoginState(usernameController.text);
      developer.log('Showing success SnackBar');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful')),
      );
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        developer.log('Navigating to LoginScreen');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } else {
      developer.log('Showing failure SnackBar: $result');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
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
        hintStyle: const TextStyle(color: tdGrey2),
        enabledBorder:
            const OutlineInputBorder(borderSide: BorderSide(color: tdGrey2)),
        focusedBorder:
            const OutlineInputBorder(borderSide: BorderSide(color: tdPurple)),
      );

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
              Text('Full name', style: _labelStyle()),
              const SizedBox(height: 8),
              TextFormField(
                controller: fullnameController,
                validator: (value) => value == null || value.isEmpty
                    ? 'Full name is required'
                    : null,
                decoration: _inputDecoration('Enter your full name'),
                style: const TextStyle(color: tdWhite),
              ),

              const SizedBox(height: 26),
              Text('Username', style: _labelStyle()),
              const SizedBox(height: 8),
              TextFormField(
                controller: usernameController,
                validator: (value) => value == null || value.isEmpty
                    ? 'Username is required'
                    : null,
                decoration: _inputDecoration('Enter your username'),
                style: const TextStyle(color: tdWhite),
              ),

              const SizedBox(height: 26),
              Text('Password', style: _labelStyle()),
              const SizedBox(height: 8),
              TextFormField(
                controller: passwordController,
                obscureText: _obsPass,
                validator: (value) => value == null || value.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
                decoration: _inputDecoration('Password').copyWith(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obsPass = !_obsPass;
                      });
                    },
                    icon: Icon(
                      _obsPass ? Icons.visibility_off : Icons.visibility,
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
                obscureText: _obsConfirm,
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
                        _obsConfirm = !_obsConfirm;
                      });
                    },
                    icon: Icon(
                      _obsConfirm ? Icons.visibility_off : Icons.visibility,
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
              const Row(
                children: [
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
}