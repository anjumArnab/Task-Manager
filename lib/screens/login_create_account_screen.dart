import 'package:database_app/services/firebase_auth_methods.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'task_manager.dart';

class LoginCreateAccountScreen extends StatefulWidget {
  const LoginCreateAccountScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginCreateAccountScreenState createState() =>
      _LoginCreateAccountScreenState();
}

class _LoginCreateAccountScreenState extends State<LoginCreateAccountScreen> {
  bool _isLoginScreen = true; // Toggle between login and create account screen
  bool _isPasswordVisible = false; // Track password visibility

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuthMethods _authMethods =
      FirebaseAuthMethods(FirebaseAuth.instance);

  void _toggleScreens() {
    setState(() {
      _isLoginScreen = !_isLoginScreen;
    });
  }

  void _authenticate() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (_isLoginScreen) {
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
    } else {
      // Sign up
      await _authMethods.signUpWithEmail(
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
                Text(
                  _isLoginScreen ? 'Login' : 'Create Account',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple.shade300),
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
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple.shade300),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.purple.shade300),
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
                OutlinedButton(
                  onPressed: _authenticate,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                    side: BorderSide(color: Colors.purple.shade300, width: 1),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                  ),
                  child: Text(
                    _isLoginScreen ? 'Login' : 'Create Account',
                    style: TextStyle(
                      color: Colors.purple.shade300,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.blue),
                    children: [
                      TextSpan(
                        text: _isLoginScreen
                            ? 'Don\'t have an account? '
                            : 'Already have an account? ',
                        style: const TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: _isLoginScreen ? 'Create one' : 'Log In',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.blueAccent,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = _toggleScreens,
                      ),
                    ],
                  ),
                ),
                if (_isLoginScreen)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: OutlinedButton(
                  onPressed: _authenticateWithGoogle,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                    side: BorderSide(color: Colors.purple.shade300, width: 1),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                  ),
                  child: Text(
                    'Sign in with Google',
                    style: TextStyle(
                      color: Colors.purple.shade300,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
