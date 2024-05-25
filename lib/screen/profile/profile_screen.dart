import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'user_training_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: (FirebaseAuth.instance.currentUser == null)
          ? Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                },
                child: const Text('Back to Home'),
              ),
            )
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.data!.exists) {
                  return const Center(child: Text('No data found!'));
                }

                var userData = snapshot.data!;
                List trainings = userData.get('trainings') ?? [];

                return SingleChildScrollView(
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 1080),
                      padding: MediaQuery.of(context).size.width > 700
                          ? const EdgeInsets.symmetric(horizontal: 100)
                          : const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Card(
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 32, 16, 16),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    userData.get('name') ?? 'No Name',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Chip(
                                    label: Text(
                                      '${userData.get('member') ?? 'Unknown'} Member',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  Text(
                                    'Mobile: ${userData.get('mobile') ?? 'No Mobile'}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Email: ${userData.get('email') ?? 'No Email'}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Institute',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${userData.get('institute') ?? 'No Institute'}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          if (trainings.isNotEmpty)
                            Text(
                              'Trainings',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          const SizedBox(height: 12),
                          TrainingList(trainings: trainings),
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

//

class TrainingList extends StatelessWidget {
  final List<dynamic> trainings;

  const TrainingList({super.key, required this.trainings});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: trainings.map((route) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('trainings')
              .where('route', isEqualTo: route)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading titles'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No trainings found'));
            }

            var training = snapshot.data!.docs.first;
            String title = training.get('title') ?? 'No title';
            String batch = training.get('batch') ?? 'No batch';

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserTrainingScreen(
                      training: training,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  title: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Batch $batch'),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
