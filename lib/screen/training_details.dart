import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/screen/training.dart';

class TrainingDetails extends StatelessWidget {
  const TrainingDetails({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trainingList[index]['title']),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1080),
            padding: MediaQuery.of(context).size.width > 600
                ? const EdgeInsets.symmetric(horizontal: 100, vertical: 16)
                : const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // eligible
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black45),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Eligibility:'),
                      const SizedBox(height: 4),
                      Text(
                        'Psychology Student (4th Year, Masters, ++)',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),

                // location
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black45),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Location:'),
                      const SizedBox(height: 4),
                      Text(
                        'Counseling Room (Ground Floor), Biological Science Faculty,\nDepartment of Psychology, University of Chittagong',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),

                // schedule
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black45),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Schedule:'),
                      const SizedBox(height: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: trainingList[index]['schedule']
                            .map<Widget>((schedule) => Text(
                                  schedule,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ))
                            .toList(),
                      )
                    ],
                  ),
                ),

                //amount
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black45),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Amount:'),
                      const SizedBox(height: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: trainingList[index]['amount']
                            .map<Widget>((amount) => Text(
                                  amount,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ))
                            .toList(),
                      )
                    ],
                  ),
                ),

                // trainer
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black45),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Trainer:'),
                      const SizedBox(height: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: trainingList[index]['trainer']
                            .map<Widget>((trainer) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        trainer['name'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      Text(
                                        trainer['status'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      )
                    ],
                  ),
                ),

                // registration
                const SizedBox(height: 32),
                if (trainingList[index]['amount'][0] != 'Currently unavailable')
                  ElevatedButton(
                    onPressed: () {
                      if (FirebaseAuth.instance.currentUser != null) {
                        Navigator.pushNamed(context, '/payment',
                            arguments: index);
                      } else {
                        Navigator.pushNamed(
                          context,
                          '/login',
                          arguments: "/${trainingList[index]['route']}",
                        );
                      }
                    },
                    child: Text('Register Now'.toUpperCase()),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  String adminNumber = '01704340860';
  String amount = '';
  String reference = '';
  bool isOfflinePayment = false; //
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final index = ModalRoute.of(context)!.settings.arguments as int?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 450,
          ),
          padding: const EdgeInsets.all(16),
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
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                      child: Column(
                        children: [
                          // Online payment content
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Please ',
                                  style: TextStyle(color: Colors.black),
                                ),
                                const TextSpan(
                                  text: 'send money',
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
                                        ClipboardData(text: adminNumber),
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
                                      ' (bkash/Nagad).\nThen provide payment ',
                                  style: TextStyle(color: Colors.black),
                                ),
                                const TextSpan(
                                  text: 'Amount & Mobile Number',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' to proceed your registration.',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                              style: const TextStyle(
                                height: 1.5,
                                fontFamily: 'Montserrat-Regular',
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
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    amount = value;
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
                                      borderRadius: BorderRadius.circular(8),
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
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                      child: Column(
                        children: [
                          // Offline payment content
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Please enter',
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: ' Receiver Name',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent,
                                  ),
                                ),
                                TextSpan(
                                  text: ' (who accept your payment) ',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                              style: TextStyle(
                                height: 1.5,
                                fontFamily: 'Montserrat-Regular',
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
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    amount = value;
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
                                      borderRadius: BorderRadius.circular(8),
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
                const SizedBox(height: 24),
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
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (amount.isEmpty || reference.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all field'),
                        ),
                      );

                      //
                    } else {
                      await submitForm(context, index, amount, reference);
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
      ),
    );
  }

  submitForm(context, index, amount, reference) async {
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
        'trainingCode': trainingList[index]['trainingCode'],
        'payment': {
          'method': isOfflinePayment ? "Offline" : "Online",
          'amount': amount.trim(),
          'reference': reference.trim(),
          'status': 'Pending',
        },
        'timestamp': FieldValue.serverTimestamp(),
      }).then((val) async {
        //
        Navigator.pushNamedAndRemoveUntil(context, '/submit', (route) => false);
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
