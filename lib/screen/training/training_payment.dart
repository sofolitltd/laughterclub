import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TrainingPayment extends StatefulWidget {
  const TrainingPayment({super.key, required this.routeName});
  final String routeName;

  @override
  State<TrainingPayment> createState() => _TrainingPaymentState();
}

class _TrainingPaymentState extends State<TrainingPayment> {
  String adminNumber = '01704340860';
  String fee = '';
  String reference = '';
  bool isOfflinePayment = false; //
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 450,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              //
              Text(
                'Payment',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
              ),
              //
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //online
                      if (!isOfflinePayment)
                        Card(
                          margin: EdgeInsets.zero,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                            child: Column(
                              children: [
                                // Online payment content
                                Container(
                                  constraints: const BoxConstraints(
                                    minHeight: 72,
                                  ),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Please ',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        const TextSpan(
                                          text: 'Send Money',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: ' to ',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        TextSpan(
                                          text: adminNumber,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.redAccent,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Clipboard.setData(
                                                ClipboardData(
                                                    text: adminNumber),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    '$adminNumber copied to clipboard',
                                                  ),
                                                ),
                                              );
                                            },
                                        ),
                                        const TextSpan(
                                          text:
                                              ' (bkash/Nagad).\nThen provide ',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        const TextSpan(
                                          text:
                                              'Payment Amount & Mobile Number',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const TextSpan(
                                          text:
                                              ' to proceed your registration.',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                      style: const TextStyle(
                                        height: 1.5,
                                        fontFamily: 'Montserrat-Regular',
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Text fields for online payment
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: TextField(
                                        decoration: InputDecoration(
                                          labelText: 'Amount',
                                          hintText: 'Enter amount',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          fee = value;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      flex: 4,
                                      child: TextField(
                                        decoration: InputDecoration(
                                          labelText: 'Mobile Number',
                                          hintText: 'Enter mobile number',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        keyboardType: TextInputType.phone,
                                        onChanged: (value) {
                                          reference = value;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (isOfflinePayment)
                        Card(
                          margin: EdgeInsets.zero,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                            child: Column(
                              children: [
                                // Offline payment content
                                Container(
                                  constraints: const BoxConstraints(
                                    minHeight: 72,
                                  ),
                                  child: RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Please enter',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        TextSpan(
                                          text: ' Payment Amount',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' and ',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        TextSpan(
                                          text: 'Receiver Name',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              ' (who accept your payment) to proceed your registration.',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                      style: TextStyle(
                                        height: 1.5,
                                        fontFamily: 'Montserrat-Regular',
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Text fields for offline payment
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: TextField(
                                        decoration: InputDecoration(
                                          labelText: 'Amount',
                                          hintText: 'Enter amount',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          fee = value;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      flex: 4,
                                      child: TextField(
                                        decoration: InputDecoration(
                                          labelText: 'Receiver Name',
                                          hintText: 'Receiver Name',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        keyboardType: TextInputType.name,
                                        onChanged: (value) {
                                          reference = value;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Switch(
                            value: isOfflinePayment,
                            onChanged: (value) {
                              setState(() {
                                isOfflinePayment = value;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'I used offline payment method',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () async {
                          if (fee.isEmpty || reference.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill all field'),
                              ),
                            );

                            //
                          } else {
                            await submitPayment(context, fee, reference);
                          }
                        },
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Proceed'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //
  submitPayment(context, fee, reference) async {
    setState(() {
      _isLoading = true;
    });

    var user = FirebaseAuth.instance.currentUser!;
    var name = '';

    var userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    //
    await userRef.get().then((value) {
      name = value.get('name');
    });

    try {
      await FirebaseFirestore.instance.collection('payments').add({
        'name': name,
        'email': user.email,
        'uid': user.uid,
        'route': widget.routeName,
        'payment': {
          'method': isOfflinePayment ? "Offline" : "Online",
          'fee': fee.trim(),
          'reference': _capitalizeEachWord(reference.trim()),
          'status': 'Pending',
        },
        'timestamp': FieldValue.serverTimestamp(),
      }).then((val) async {
        //
        Navigator.pushReplacementNamed(context, '/');
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

//
String _capitalizeEachWord(String input) {
  if (input.isEmpty) return input;
  return input.trim().split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}
