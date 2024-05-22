import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    required this.title,
    required this.amount,
    required this.mobile,
    required this.trnID,
  });

  final String title;
  final String amount;
  final String mobile;
  final String trnID;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _instituteController = TextEditingController();

  bool _isLoading = false;

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
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await FirebaseFirestore.instance.collection('training').add({
          'name': capitalizeEachWord(_nameController.text.trim()),
          'mobileNo': _mobileNumberController.text.trim(),
          'email': _emailController.text.trim(),
          'institute': capitalizeEachWord(_instituteController.text.trim()),
          'training': widget.title,
          'payment': {
            'amount': widget.amount.trim(),
            'mobile': widget.mobile.trim(),
            'transactionID': widget.trnID.trim().toUpperCase(),
            'status': 'Pending',
          },
          'timestamp': FieldValue.serverTimestamp(),
        }).then((val) {
          //
          Navigator.pushNamedAndRemoveUntil(
              context, '/submit', (route) => false);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit form: $e')),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 1080,
          ),
          padding: MediaQuery.of(context).size.width > 600
              ? const EdgeInsets.symmetric(horizontal: 100, vertical: 16)
              : const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                //
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Payment with: ',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                    children: [
                      TextSpan(
                        text: widget.mobile,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: ' - '),
                      TextSpan(
                        text: widget.trnID,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                //
                const SizedBox(height: 16),
                Text.rich(
                  TextSpan(
                    text: 'Please provide your ', // Regular text
                    style: Theme.of(context).textTheme.titleSmall,
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            'full name for the certificate', // Bold and red text
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                      ),
                      const TextSpan(
                        text:
                            ', a WhatsApp-enabled mobile number, and a valid email address.', // Regular text
                      ),
                    ],
                  ),
                ),

                //
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),

                //
                const SizedBox(height: 16),
                TextFormField(
                  controller: _mobileNumberController,
                  decoration: InputDecoration(
                    labelText: 'Mobile',
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

                //
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
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

                //
                const SizedBox(height: 16),
                TextFormField(
                  controller: _instituteController,
                  decoration: InputDecoration(
                    labelText: 'Institute',
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

                //
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(),
                        )
                      : Text('Submit'.toUpperCase()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
