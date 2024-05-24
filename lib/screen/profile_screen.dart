import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laughterclub/screen/training.dart';
import 'package:url_launcher/url_launcher.dart';

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
                child: const Text('BAck to Home'),
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
                List userTrainingCodes = userData.get('training');

                // Filter the trainingList based on user's training codes
                var userTrainings = trainingList.where((training) {
                  return userTrainingCodes.contains(training['trainingCode']);
                }).toList();

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
                          // 1
                          Card(
                            margin: EdgeInsets.zero,
                            // color: Colors.white,
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
                                    userData.get('name'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Chip(
                                    label: Text(
                                      '${userData.get('member')} Member',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  Text(
                                    'Mobile: ${userData.get('mobile')}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Email: ${userData.get('email')}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Institute: ${userData.get('institute')}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ),

                          //
                          const SizedBox(height: 32),

                          Text(
                            'Trainings',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  MediaQuery.of(context).size.width < 600
                                      ? 2
                                      : 3,
                              childAspectRatio: 3,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                            ),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: userTrainings.length,
                            itemBuilder: (context, index) {
                              var training = userTrainings[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TrainingDetailScreen(
                                              training: training),
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Center(
                                      child: Text(
                                        training['title'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
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

class TrainingDetailScreen extends StatelessWidget {
  final Map training;

  const TrainingDetailScreen({super.key, required this.training});

  Future<void> _launchInURL(String link) async {
    var url = Uri.parse(link);

    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppBrowserView,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLargeScreen = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(training['title']),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Schedule',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          for (var schedule in training['schedule'])
                            Text(
                              schedule,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          const SizedBox(height: 16),
                          Text(
                            'Amount',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          for (var amount in training['amount'])
                            Text(
                              amount,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          const SizedBox(height: 16),
                          Text(
                            'Trainers',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          for (var trainer in training['trainer'])
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  trainer['name'],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Text(
                                  trainer['status'],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    'Resources',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  //
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('training')
                        .where('trainingCode',
                            isEqualTo: training['trainingCode'])
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Text('No files available');
                      }
                      var data = snapshot.data!.docs;

                      if (isLargeScreen) {
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 3,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            var files =
                                data[index].get('files') as List<dynamic>;
                            return Wrap(
                              spacing: 16.0, // Horizontal spacing between cards
                              runSpacing:
                                  16.0, // Vertical spacing between cards
                              children: files.map<Widget>((file) {
                                return Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: ListTile(
                                    title: Text(file['name']),
                                    onTap: () => _launchInURL(file['url']),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        );
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            var files =
                                data[index].get('files') as List<dynamic>;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Wrap(
                                spacing:
                                    16.0, // Horizontal spacing between cards
                                runSpacing:
                                    16.0, // Vertical spacing between cards
                                children: files.map<Widget>((file) {
                                  return Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: ListTile(
                                      title: Text(file['name']),
                                      onTap: () => _launchInURL(file['url']),
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
