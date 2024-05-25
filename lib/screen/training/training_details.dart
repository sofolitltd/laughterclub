import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrainingDetail extends StatelessWidget {
  final String routeName;

  const TrainingDetail({super.key, required this.routeName});

  @override
  Widget build(BuildContext context) {
    String title = "";

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('trainings')
            .where('route', isEqualTo: routeName)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Training not found!',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                //
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                  child: const Text('Back to Home'),
                ),
              ],
            ));
          }

          var trainings = snapshot.data!.docs;
          QueryDocumentSnapshot? training;

          for (var t in trainings) {
            training = t;
          }

          title = "${training!.get('title')} (Batch ${training.get('batch')})";

          // Get the last date for registration
          Timestamp dateCloseTimestamp = training.get('dateClose');
          DateTime lastDate = dateCloseTimestamp.toDate();
          String deadLine =
              DateFormat('dd MMMM, yyyy  - h:mm a').format(lastDate);

          bool isExpired = DateTime.now().isAfter(lastDate);

          return SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1080),
                padding: MediaQuery.of(context).size.width > 600
                    ? const EdgeInsets.symmetric(horizontal: 100, vertical: 16)
                    : const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                    ),
                    const SizedBox(height: 24),

                    // eligibility
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
                            training.get('eligibility'),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
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
                          const Text('Place:'),
                          const SizedBox(height: 4),
                          Text(
                            training.get('place'),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
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
                          const Text('Schedules:'),
                          const SizedBox(height: 4),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: training
                                .get('schedules')
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

                    // fees
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
                          const Text('Fees:'),
                          const SizedBox(height: 4),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: training
                                .get('fees')
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

                    // trainers
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
                          const Text('Trainers:'),
                          const SizedBox(height: 4),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: training
                                .get('trainers')
                                .map<Widget>((trainer) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
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
                                            trainer['post'],
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

                    const SizedBox(height: 16),

                    // deadline
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black45),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Deadline:'),
                          const SizedBox(width: 8),
                          Text(
                            deadLine,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    //
                    ElevatedButton(
                      onPressed: isExpired
                          ? null
                          : () {
                              if (FirebaseAuth.instance.currentUser != null) {
                                Navigator.pushNamed(
                                    context, '/$routeName/payment');
                              } else {
                                Navigator.pushNamed(
                                  context,
                                  '/login',
                                  arguments: "/$routeName",
                                );
                              }
                            },
                      child: isExpired
                          ? Text(
                              'Registration Closed'.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Text('Register Now'.toUpperCase()),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
