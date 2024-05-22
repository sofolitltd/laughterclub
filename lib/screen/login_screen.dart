import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  void _login(route) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      //
      //
      String _getErrorMessage(String errorCode) {
        switch (errorCode) {
          case 'invalid-email':
            return 'The email address is not valid.';
          case 'user-disabled':
            return 'The user account has been disabled.';
          case 'user-not-found':
            return 'No user found for this email.';
          case 'wrong-password':
            return 'Incorrect password provided.';
          default:
            return 'An unknown error occurred.';
        }
      }

      //
      try {
        var userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (userCredential.user!.uid.isEmpty) return;
        print('login');

        Navigator.pushNamedAndRemoveUntil(
            context, route.toString(), (route) => false);
      } on FirebaseAuthException catch (e) {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Login Failed: ${_getErrorMessage(e.code)}')),
          );
        });
      } catch (e) {
        print('$e');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Failed: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context)!.settings.arguments as String?;
    print(route);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Align(
          // alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              padding: const EdgeInsets.all(16.0),
              // margin: const EdgeInsets.only(top: 40),
              child: Form(
                key: _formKey,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 32, horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Already have an account?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              // color: Colors.red,
                            )),
                        const SizedBox(height: 8),
                        //
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter Login Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter Strong Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => _login(route),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(),
                                )
                              : const Text('Login'),
                        ),
                        const SizedBox(height: 32),
                        const Text('Don\'t have an account yet? Create One',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            )),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/register',
                              arguments: route,
                            );
                          },
                          child: const Text('Create New Account'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
