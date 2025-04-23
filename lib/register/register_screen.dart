import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_todo_app/login/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
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
        leading: BackButtonCustom(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 16),
              Text(
                'Register',
                style: TextStyle(
                  color: tdWhite,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Lato',
                ),
              ),

              SizedBox(height: 24),
              Text('Username', style: _labelStyle()),

              SizedBox(height: 8),
              TextFormField(
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Username is required'
                            : null,
                decoration: _inputDecoration('Enter your Username'),
              ),

              SizedBox(height: 26),
              Text('Password', style: _labelStyle()),

              SizedBox(height: 8),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                validator:
                    (value) =>
                        value == null || value.length < 6
                            ? 'Password must be at least 6 characters'
                            : null,
                decoration: _inputDecoration('Password'),
              ),

              SizedBox(height: 26),
              Text('Confirm Password', style: _labelStyle()),

              SizedBox(height: 8),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                decoration: _inputDecoration('Re-enter your password'),
              ),

              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print("Đăng ký thành công!");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: tdPurple,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Register', style: TextStyle(color: tdWhite)),
              ),

              SizedBox(height: 32),
              Row(
                children: [
                  Expanded(child: Divider(color: tdGrey2)),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
                    child: Text('or', style: TextStyle(color: tdGrey2)),
                  ),
                  Expanded(child: Divider(color: tdGrey2)),
                ],
              ),

              SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () {},
                icon: SvgPicture.asset('assets/icons/google.svg', width: 20),
                label: Text('Register with Google'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: tdWhite,
                  side: BorderSide(color: tdPurple),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  minimumSize: Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              SizedBox(height: 18),
              OutlinedButton.icon(
                onPressed: () {},
                icon: SvgPicture.asset('assets/icons/apple.svg', width: 20),
                label: Text('Register with Google'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: tdWhite,
                  side: BorderSide(color: tdPurple),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  minimumSize: Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              SizedBox(height: 46),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text.rich(
                    TextSpan(
                      text: "Already have an account?  ",
                      style: TextStyle(color: tdWhite),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: const TextStyle(
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

  TextStyle _labelStyle() => TextStyle(
    color: tdWhite,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: 'Lato',
  );

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: tdGrey2),
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: tdGrey2)),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: tdPurple)),
  );
}

class BackButtonCustom extends StatelessWidget {
  const BackButtonCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios, color: tdWhite),
      onPressed: () => Navigator.pop(context),
    );
  }
}
