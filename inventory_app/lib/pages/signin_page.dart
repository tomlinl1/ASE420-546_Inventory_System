import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase('http://127.0.0.1:8090'); 

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  // Sign In Logic
  Future<void> _signIn() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() {
    _isLoading = true;
    _error = null;
  });

  try {
    final authData = await pb.collection('users').authWithPassword(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    // If login success → go to home
    if (authData.record != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _error = "Authentication failed. Please try again.";
      });
    }
  } catch (e) {
    setState(() {
      _error = "Invalid credentials or network issue.";
    });
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}


  // Navigate to Sign Up
  void _create() {
    Navigator.pushReplacementNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Sign In",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter your email'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter your password'
                          : null,
                    ),

                    const SizedBox(height: 24),

                    // Error message
                    if (_error != null)
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),

                    const SizedBox(height: 16),

                    // Sign In button with loading spinner
                    ElevatedButton(
                      onPressed: _isLoading ? null : _signIn,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text("Sign In"),
                    ),

                    const SizedBox(height: 16),

                    // Create Account prompt
                    Text(
                      "Don’t have an account? Create one below:",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700],
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),

                    // Create Account button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _create,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Create Account"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
