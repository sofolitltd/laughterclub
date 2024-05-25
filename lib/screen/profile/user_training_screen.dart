import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UserTrainingScreen extends StatelessWidget {
  final QueryDocumentSnapshot training;

  const UserTrainingScreen({super.key, required this.training});

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
        title: Text('${training['title']}(Batch ${training['batch']})'),
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
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Schedules',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          for (var schedule in training['schedules'] ?? [])
                            Text(
                              schedule,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          const SizedBox(height: 16),
                          Text(
                            'Fees',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          for (var amount in training['fees'] ?? [])
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
                          for (var trainer in training['trainers'] ?? [])
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  trainer['name'] ?? 'No name',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Text(
                                  trainer['post'] ?? 'No status',
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

                  //
                  Text(
                    'Resources',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('trainings')
                        .doc(training.id)
                        .collection('resources')
                        .orderBy('day')
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
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 3,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            var file =
                                data[index].data() as Map<String, dynamic>;
                            return Card(
                              elevation: 2,
                              child: ListTile(
                                title: Text(
                                  '${file['title']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text('Day ${file['day']}'),
                                onTap: () => _launchInURL(file['url']),
                              ),
                            );
                          },
                        );
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            var file =
                                data[index].data() as Map<String, dynamic>;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ListTile(
                                  title: Text(
                                    file['title'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text('Day ${file['day']}'),
                                  onTap: () => _launchInURL(file['url']),
                                ),
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
