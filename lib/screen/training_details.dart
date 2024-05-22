import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/screen/training.dart';
import 'register_screen.dart';

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
                      showDialog(
                        context: context,
                        builder: (context) {
                          String adminNumber = '01704340860';
                          String amount = '';
                          String mobileNumber = '';
                          String transactionID = '';

                          return AlertDialog(
                            title: const Text('Payment'),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RichText(
                                  text: TextSpan(children: [
                                    const TextSpan(
                                      text: 'Please ',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    const TextSpan(
                                      text: 'send money',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
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
                                          color: Colors.redAccent),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Clipboard.setData(
                                              ClipboardData(text: adminNumber));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    '$adminNumber copied to clipboard')),
                                          );
                                        },
                                    ),
                                    const TextSpan(
                                      text:
                                          ' (bkash).\nThen provide your payment ',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    const TextSpan(
                                      text: 'Amount, Mobile Number',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    const TextSpan(
                                      text: ' and',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    const TextSpan(
                                      text: ' Transaction ID',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    const TextSpan(
                                      text: ' to proceed your registration.',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ], style: const TextStyle(height: 1.4)),
                                ),

                                // Assuming the user needs to enter the transaction ID
                                const SizedBox(height: 16),
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
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        keyboardType: TextInputType.phone,
                                        onChanged: (value) {
                                          mobileNumber = value;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Transaction ID',
                                    hintText: 'Enter transaction ID',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    transactionID = value;
                                  },
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the dialog
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (amount.isEmpty ||
                                      mobileNumber.isEmpty ||
                                      transactionID.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please fill amount, mobile and transID')));
                                  } else {
                                    Navigator.pop(context); // Close the dialog
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RegisterScreen(
                                          title: trainingList[index]['title'],
                                          amount: amount,
                                          mobile: mobileNumber,
                                          trnID: transactionID,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Text('Proceed'),
                              ),
                            ],
                          );
                        },
                      );
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
