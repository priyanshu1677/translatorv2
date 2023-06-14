import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:translator/components/my_button.dart';
import 'package:translator/components/my_textfield.dart';
import 'package:translator/components/square_tile.dart';
import 'package:translator/routes/app_route_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:translator/services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _phoneController = TextEditingController().value;

  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  void signIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showDialog(
            context: context,
            builder: (context) {
              return const Center(child: Text('No user found for this email!'));
            });
      } else if (e.code == 'wrong-password') {
        showDialog(
            context: context,
            builder: (context) {
              return const Center(child: Text('Incorrect Password!'));
            });
      }
    }
    context.pop();
  }

  Future signInWithPhone() async {
    await FirebaseAuth.instance
        .signInWithPhoneNumber(_phoneController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              Text(
                'Welcome!',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              MyTextField(
                controller: _emailController,
                hintText: 'Email',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              MyTextField(
                controller: _passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 10),

              MyTextField(
                controller: _confirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),

              const SizedBox(height: 25),

              // sign in button
              MyButton(
                onTap: () {
                  signIn();
                  context.goNamed(MyAppRouteConstants.homeRouteName);
                },
              ),

              const SizedBox(height: 50),

              // or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        AuthService().signInWithGoogle();
                      },
                      child:
                          const SquareTile(imagePath: 'lib/images/google.png')),
                  const SizedBox(width: 25),
                  GestureDetector(
                      onTap: () {
                        signInWithPhone();
                        context.goNamed(MyAppRouteConstants.homeRouteName);
                      },
                      child:
                          const SquareTile(imagePath: 'lib/images/phone.png')),
                ],
              ),

              const SizedBox(height: 50),

              // not a member? SignUp Now!
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already a member?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      context.goNamed(MyAppRouteConstants.loginRouteName);
                    },
                    child: const Text(
                      'Login Now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
