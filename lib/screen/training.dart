import 'dart:ui';

import 'package:flutter/material.dart';

final List trainingList = [
  {
    'title': 'Basic Counseling',
    'route': 'basic-counseling',
    'trainingCode': 'basic-counseling-2401',
    'image': 'https://via.placeholder.com/150',
    'schedule': [
      '23 May(02:00 pm - 04:30 pm)',
      '24 May(09:30 pm - 04:30 pm)',
      '25 May(09:30 pm - 04:30 pm)'
    ],
    'amount': ['2500 TK (General Member)', '2200 Tk (Laughter Club Member)'],
    'trainer': [
      {
        'name': 'Dr. Shahinoor Rahman',
        'status': 'Associate Professor, Department of Psychology, CU'
      },
      {
        'name': 'Tofa Hakim',
        'status': 'Consultant Psychologist, Serenity, Chittagong'
      },
    ],
  },
  {
    'title': 'Advanced Counseling',
    'route': 'advanced-counseling',
    'trainingCode': 'advanced-counseling-2401',
    'image': 'https://via.placeholder.com/150',
    'schedule': [
      'Currently unavailable',
    ],
    'amount': [
      'Currently unavailable',
    ],
    'trainer': [
      {'name': 'Currently unavailable', 'status': ''},
    ],
  },
  {
    'title': 'CBT (Cognitive Behavior Therapy)',
    'route': 'cbt',
    'trainingCode': 'cbt-2401',
    'image': 'https://via.placeholder.com/150',
    'schedule': [
      'Currently unavailable',
    ],
    'amount': [
      'Currently unavailable',
    ],
    'trainer': [
      {'name': 'Currently unavailable', 'status': ''},
    ],
  },
];

class Training extends StatelessWidget {
  const Training({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Text(
            'Training',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1.2),
          ),
        ),

        //
        SizedBox(
          height: 240,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: ListView.separated(
              primary: true,
              padding: const EdgeInsets.symmetric(vertical: 16),
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              scrollDirection: Axis.horizontal,
              itemCount: trainingList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "/${trainingList[index]['route']}",
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: Container(
                      width: 180,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //
                          Expanded(
                            flex: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.amber.shade100,
                                // image: DecorationImage(
                                //   fit: BoxFit.cover,
                                //   image: NetworkImage(
                                //     trainingList[index]['image']!,
                                //   ),
                                // ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),
                          //
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Text(
                                trainingList[index]['title']!,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      // height: 1.2,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
