import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TrainingMemberScreen extends StatefulWidget {
  const TrainingMemberScreen({super.key});

  @override
  State<TrainingMemberScreen> createState() => _TrainingMemberScreenState();
}

class _TrainingMemberScreenState extends State<TrainingMemberScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('payments')
            .where('payment.status', isEqualTo: 'Completed')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data Found!'));
          }

          var data = snapshot.data!.docs;

          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1080),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Total member: ${data.length}'),
                      ),

                      //todo
                      // ElevatedButton(
                      //   onPressed: () async {
                      //     const delay = Duration(milliseconds: 500);
                      //     setState(() {
                      //       _isLoading = true;
                      //     });
                      //
                      //     //
                      //     for (var i = 0; i < data.length; i++) {
                      //       await Future.delayed(delay);
                      //
                      //
                      //       await PdfGenerator.createCertificate(
                      //           data[i].get('name'));
                      //
                      //       setState(() {
                      //         _isLoading = false;
                      //       });
                      //     }
                      //   },
                      //   child: _isLoading
                      //       ? const Row(
                      //           mainAxisSize: MainAxisSize.min,
                      //           children: [
                      //             SizedBox(
                      //                 height: 24,
                      //                 width: 24,
                      //                 child: CircularProgressIndicator()),
                      //             SizedBox(width: 8),
                      //             Text('Generating Certificate...'),
                      //           ],
                      //         )
                      //       : const Text('Generate Certificate for All'),
                      // ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  //
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: data.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(),
                          ),
                          padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //
                              Text(
                                data[index].get('name'),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),

                              //
                              Text(
                                data[index].get('mobileNo'),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(),
                              ),

                              //
                              Text(
                                data[index].get('email'),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(),
                              ),

                              //
                              Text(
                                data[index].get('institute'),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
