import 'package:database_app/screens/create_account.dart';
import 'package:database_app/services/firebase_auth_methods.dart';
import 'package:database_app/widgets/custom_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'task_manager.dart';

class LoginCreateAccountScreen extends StatefulWidget {
  const LoginCreateAccountScreen({super.key});

  @override
  _LoginCreateAccountScreenState createState() =>
      _LoginCreateAccountScreenState();
}

class _LoginCreateAccountScreenState extends State<LoginCreateAccountScreen> {
  bool _isPasswordVisible = false; // Track password visibility

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuthMethods _authMethods =
      FirebaseAuthMethods(FirebaseAuth.instance);

  void _authenticate() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Log in
    await _authMethods.logInWithEmail(
      email: email,
      password: password,
      context: context,
    );
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TaskManager()),
      );
    }
  }
  void _authenticateWithGoogle() async {
    await _authMethods.signInWithGoogle(context);
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TaskManager()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Manager"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                ),
                const SizedBox(height: 16),
                CustomOutlinedButton(
                  onPressed: _authenticate,
                  text: 'Login',
                ),
                const SizedBox(height: 15),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.blue),
                    children: [
                      const TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'Create one',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.blueAccent,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CreateAccountScreen(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: CustomOutlinedButton(
                    onPressed: () {}, // Keep the button interactive
                    text: 'Sign in with Google',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
