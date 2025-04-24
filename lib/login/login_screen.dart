import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_todo_app/register/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

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
              SizedBox(height: 40),
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Lato',
                  color: tdWhite,
                ),
              ),
              SizedBox(height: 52),

              Text('Username', 
              style: 
              TextStyle(color: tdWhite)),
              SizedBox(height: 8),
              TextFormField(
                controller: usernameController,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Username is required' : null,
                decoration: InputDecoration(
                  hintText: 'Enter your Username',
                  hintStyle: 
                  TextStyle(color: tdGrey),
                  enabledBorder: 
                  OutlineInputBorder(
                  borderSide: 
                  BorderSide(color: tdGrey),
                  ),
                  focusedBorder:  
                  OutlineInputBorder(
                  borderSide: 
                  BorderSide(color: tdPurple),
                  ),
                ),
                style:  
                TextStyle(color: tdWhite),
              ),
              SizedBox(height: 26),

              Text('Password', 
              style: 
              TextStyle(color: tdWhite)),
              SizedBox(height: 8),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                validator: (value) => value == null || value.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: 
                  TextStyle(color: tdGrey),
                  enabledBorder: 
                  OutlineInputBorder(
                    borderSide: BorderSide(color: tdGrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: tdPurple),
                  ),
                ),
                style: 
                TextStyle(color: tdWhite),
              ),
              const SizedBox(height: 70),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      debugPrint('Username: ${usernameController.text}');
                      debugPrint('Password: ${passwordController.text}');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tdPurple,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: 
                  Text('Login', 
                  style: TextStyle(color: tdWhite)),
                ),
              ),
              SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                  child: 
                  Divider(color: tdGrey2)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: 
                    Text('or', 
                    style: TextStyle(color: tdGrey2)),
                  ),
                  Expanded(
                    child:
                    Divider(color: tdGrey2)),
                ],
              ),
              SizedBox(height: 40),

              OutlinedButton.icon(
                onPressed: () {},
                icon: SvgPicture.asset('assets/icons/google.svg', width: 20),
                label:
                Text('Login with Google'),
                style: 
                OutlinedButton.styleFrom(
                  foregroundColor: tdWhite,
                  side: BorderSide(color: tdPurple),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  minimumSize: Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 20),

              OutlinedButton.icon(
                onPressed: () {},
                icon: SvgPicture.asset('assets/icons/apple.svg', width: 20),
                label: 
                Text('Login with Apple'),
                style: 
                OutlinedButton.styleFrom(
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()
                    ),
                    ); 
                  },
                  child: Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      style:
                      TextStyle(color: tdWhite),
                      children: [
                        TextSpan(
                          text: 'Register',
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