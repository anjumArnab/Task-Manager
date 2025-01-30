import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:database_app/services/firebase_auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'task_manager.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool _isPasswordVisible = false; // Track password visibility

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuthMethods _authMethods =
      FirebaseAuthMethods(FirebaseAuth.instance);

  void _signUp() async {
    String fullName = _fullNameController.text;
    String age = _ageController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    // Validation logic (optional)
    if (fullName.isEmpty || age.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required!")),
      );
      return;
    }

    try {
      // Sign up logic
      await _authMethods.signUpWithEmail(
          email: email, password: password, context: context);

      // Check if the user was successfully signed up
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Save user details in Firestore immediately after sign-up
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'fullName': fullName,
          'age': int.tryParse(age) ?? 0, // Convert age to an integer
          'email': email,
          'createdAt': FieldValue.serverTimestamp(), // Timestamp for user creation
        });

        // Prompt the user to verify their email
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Account created! Please verify your email.")),
        );

        // Navigate to TaskManager screen (optional)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TaskManager()),
        );
      }
    } catch (e) {
      // Handle errors (e.g., show a SnackBar with the error message)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  child: IconButton(
                    icon: const Icon(Icons.add_a_photo),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    hintText: 'Enter your age',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  keyboardType: TextInputType.number,
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
                          color: Colors.black),
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
                    onPressed: _signUp, text: "Create Account"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}