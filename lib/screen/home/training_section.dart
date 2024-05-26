import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TrainingSection extends StatelessWidget {
  const TrainingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Text(
            'Trainings',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  // letterSpacing: .5,
                ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('trainings')
                .orderBy('dateOpen', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Error loading trainings'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final trainingList = snapshot.data!.docs;

              return ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: ListView.separated(
                  primary: true,
                  padding: const EdgeInsets.only(bottom: 8),
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: trainingList.length,
                  itemBuilder: (context, index) {
                    var training =
                        trainingList[index].data() as Map<String, dynamic>;
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          "/${training['route']}",
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.zero,
                        child: Container(
                          width: 215,
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 8,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.amber.shade100,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(training['image']),
                                      )),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text(
                                    training['title'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          height: 1.3,
                                        ),
                                  ),
                                ),
                              ),

                              //
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black45),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    margin: const EdgeInsets.only(
                                      left: 4,
                                      bottom: 4,
                                      top: 6,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 6,
                                        right: 8,
                                      ),
                                      child: Text(
                                        "Batch ${training['batch']}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),

                                  //
                                  const Icon(
                                    Icons.arrow_circle_right_outlined,
                                    size: 20,
                                    color: Colors.black45,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
