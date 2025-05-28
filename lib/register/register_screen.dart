import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  TextStyle _labelStyle(Color color) => TextStyle(
        color: color,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontFamily: 'Lato',
      );

  InputDecoration _inputDecoration(String hint, Color hintColor, Color borderColor, Color focusedBorderColor) => InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: hintColor),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: borderColor)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: focusedBorderColor)),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // Ví dụ:
    // colorScheme.onBackground: màu chữ chính
    // colorScheme.onSurfaceVariant: màu chữ nhẹ
    // colorScheme.primary: màu chính
    // colorScheme.surface: nền
    // colorScheme.background: nền tổng thể

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        leading: const BackButtonCustom(),
        iconTheme: IconThemeData(color: colorScheme.onBackground),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 16),
              Text(
                'Register',
                style: TextStyle(
                  color: colorScheme.onBackground,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Lato',
                ),
              ),

              const SizedBox(height: 24),
              Text('Full name', style: _labelStyle(colorScheme.onBackground)),
              const SizedBox(height: 8),
              TextFormField(
                controller: fullnameController,
                validator: (value) => value == null || value.isEmpty ? 'Full name is required' : null,
                decoration: _inputDecoration(
                  'Enter your full name',
                  colorScheme.onSurfaceVariant,
                  colorScheme.onSurfaceVariant,
                  colorScheme.primary,
                ),
                style: TextStyle(color: colorScheme.onBackground),
              ),

              const SizedBox(height: 26),
              Text('Username', style: _labelStyle(colorScheme.onBackground)),
              const SizedBox(height: 8),
              TextFormField(
                controller: usernameController,
                validator: (value) => value == null || value.isEmpty ? 'Username is required' : null,
                decoration: _inputDecoration(
                  'Enter your username',
                  colorScheme.onSurfaceVariant,
                  colorScheme.onSurfaceVariant,
                  colorScheme.primary,
                ),
                style: TextStyle(color: colorScheme.onBackground),
              ),

              const SizedBox(height: 26),
              Text('Password', style: _labelStyle(colorScheme.onBackground)),
              const SizedBox(height: 8),
              TextFormField(
                controller: passwordController,
                obscureText: _obsPass,
                validator: (value) => value == null || value.length < 6 ? 'Password must be at least 6 characters' : null,
                decoration: _inputDecoration(
                  'Password',
                  colorScheme.onSurfaceVariant,
                  colorScheme.onSurfaceVariant,
                  colorScheme.primary,
                ).copyWith(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obsPass = !_obsPass;
                      });
                    },
                    icon: Icon(
                      _obsPass ? Icons.visibility_off : Icons.visibility,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                style: TextStyle(color: colorScheme.onBackground),
              ),

              const SizedBox(height: 26),
              Text('Confirm Password', style: _labelStyle(colorScheme.onBackground)),
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
                decoration: _inputDecoration(
                  'Re-enter your password',
                  colorScheme.onSurfaceVariant,
                  colorScheme.onSurfaceVariant,
                  colorScheme.primary,
                ).copyWith(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obsConfirm = !_obsConfirm;
                      });
                    },
                    icon: Icon(
                      _obsConfirm ? Icons.visibility_off : Icons.visibility,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                style: TextStyle(color: colorScheme.onBackground),
              ),

              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Register', style: TextStyle(color: colorScheme.onPrimary)),
              ),

              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(child: Divider(color: colorScheme.onSurfaceVariant)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text('or', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                  ),
                  Expanded(child: Divider(color: colorScheme.onSurfaceVariant)),
                ],
              ),

              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () {},
                icon: SvgPicture.asset('assets/icons/google.svg', width: 20),
                label: Text('Register with Google', style: TextStyle(color: colorScheme.onBackground)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.onBackground,
                  side: BorderSide(color: colorScheme.primary),
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
                label: Text('Register with Apple', style: TextStyle(color: colorScheme.onBackground)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.onBackground,
                  side: BorderSide(color: colorScheme.primary),
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
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: Text.rich(
                    TextSpan(
                      text: "Already have an account?  ",
                      style: TextStyle(color: colorScheme.onBackground),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onBackground,
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
