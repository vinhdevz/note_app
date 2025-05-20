import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_todo_app/database/user_db.dart';
import 'package:flutter_todo_app/home/home_screen.dart';
import 'package:flutter_todo_app/register/register_screen.dart';
import 'package:flutter_todo_app/register/widgets/backButtonCustom.dart';

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
  bool _obs = true;

  @override
  void initState() {
    super.initState();
    _loadSavedLogin();
  }

  Future<void> _loadSavedLogin() async {
    final savedData = await UserDatabase.instance.getSavedLogin();
    if (savedData != null) {
      usernameController.text = savedData['username'] ?? '';
      passwordController.text = ''; 
      setState(() {
        rememberMe = true;
      });
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    final isValid = await UserDatabase.instance.checkLogin(username, password);

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid username or password')),
      );
      return;
    }

    final fullname = await UserDatabase.instance.getFullName(username);
    if (rememberMe) {
      await UserDatabase.instance.saveLoginState(username);
    } else {
      await UserDatabase.instance.clearLoginState();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login successful')),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(username: username)),
    );
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
              _buildLabel('Username'),
              const SizedBox(height: 8),
              TextFormField(
                controller: usernameController,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Username is required' : null,
                decoration: _inputDecoration('Enter your Username'),
                style: const TextStyle(color: tdWhite),
              ),
              const SizedBox(height: 26),
              _buildLabel('Password'),
              const SizedBox(height: 8),
              TextFormField(
                controller: passwordController,
                obscureText: _obs,
                validator: (value) =>
                    value == null || value.length < 6 ? 'Password must be at least 6 characters' : null,
                decoration: _inputDecoration('Password').copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obs ? Icons.visibility_off : Icons.visibility,
                      color: tdGrey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obs = !_obs;
                      });
                    },
                  ),
                ),
                style: const TextStyle(color: tdWhite),
              ),
              CheckboxListTile(
                title: const Text(
                  'Remember To Login',
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
                  onPressed: _handleLogin,
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
              const SizedBox(height: 40),
              _socialButton(
                iconPath: 'assets/icons/google.svg',
                label: 'Login with Google',
              ),
              const SizedBox(height: 20),
              _socialButton(
                iconPath: 'assets/icons/apple.svg',
                label: 'Login with Apple',
              ),
              const SizedBox(height: 46),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
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

  Widget _buildLabel(String label) => Text(
        label,
        style: const TextStyle(
          color: tdWhite,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: 'Lato',
        ),
      );

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: tdGrey),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: tdGrey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: tdPurple),
        ),
      );

  Widget _socialButton({required String iconPath, required String label}) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: SvgPicture.asset(iconPath, width: 20),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: tdWhite,
        side: const BorderSide(color: tdPurple),
        padding: const EdgeInsets.symmetric(vertical: 14),
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}