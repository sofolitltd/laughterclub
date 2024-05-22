import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _instituteController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context)!.settings.arguments as String?;

    //
    String capitalizeEachWord(String input) {
      if (input.isEmpty) {
        return input;
      }
      return input
          .split(' ')
          .map((word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
              : '')
          .join(' ');
    }

    //
    void createAccount(route) async {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });

        try {
          // Register the user with email and password
          UserCredential userCredential =
              await _auth.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

          if (userCredential.user!.uid.isEmpty) return;

          // Add user details to Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'uid': userCredential.user!.uid,
            'name': capitalizeEachWord(_nameController.text.trim()),
            'institute': capitalizeEachWord(_instituteController.text.trim()),
            'mobile': _mobileNumberController.text.trim(),
            'email': _emailController.text.trim(),
            'image': '',
            'member': 'General',
            'training': [],
            'timestamp': FieldValue.serverTimestamp(),
          }).then((val) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Successfully Create your Account')));
            //
            Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Signup Failed: $e')),
          );
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }

    //
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
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
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            hintText: 'Enter Certificate Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _instituteController,
                          decoration: InputDecoration(
                            labelText: 'Institute',
                            hintText: 'Enter University/College Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your institute';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _mobileNumberController,
                          decoration: InputDecoration(
                            labelText: 'Mobile',
                            hintText: 'Enter Mobile No',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your mobile number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter Active Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter Strong Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Text.rich(
                          TextSpan(
                            text: 'Please remember your ',
                            style: Theme.of(context).textTheme.titleSmall,
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Email',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                              ),
                              TextSpan(
                                text: ' and ',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(),
                              ),
                              TextSpan(
                                text: 'Password',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                              ),
                              TextSpan(
                                text: ' for further login. ',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () => createAccount(route),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(),
                                )
                              : Text('Create Account'.toUpperCase()),
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
