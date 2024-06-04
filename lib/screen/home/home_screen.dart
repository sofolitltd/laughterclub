import 'package:flutter/material.dart';
import 'package:laughterclub/screen/home/training_section.dart';

import 'header_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: () async {
      //   var ref = FirebaseFirestore.instance.collection('trainings');
      //
      //   //
      //   await ref.add(
      //     {
      //       'batch': '1',
      //       'dateOpen': DateTime.now(),
      //       'dateClose': DateTime.now().add(const Duration(days: 3)),
      //       'title': 'Advanced Counseling',
      //       'route': 'advanced-counseling-1',
      //       'image': 'https://via.placeholder.com/150',
      //       'place': 'Department of Psychology',
      //       'eligibility': 'Psychology Student(4th year, Masters)',
      //       'schedules': [
      //         '23 May(02:00 pm - 04:30 pm)',
      //         '24 May(09:30 pm - 04:30 pm)',
      //         '25 May(09:30 pm - 04:30 pm)'
      //       ],
      //       'fees': [
      //         '2500 TK (General Member)',
      //         '2200 Tk (Laughter Club Member)'
      //       ],
      //       'trainers': [
      //         {
      //           'name': 'Dr. Shahinoor Rahman',
      //           'post': 'Associate Professor, Department of Psychology, CU',
      //           'image': ''
      //         },
      //         {
      //           'name': 'Tofa Hakim',
      //           'post': 'Consultant Psychologist, Serenity, Chittagong',
      //           'image': ''
      //         },
      //       ],
      //       'certificate': {
      //         'position': 195,
      //         'background':
      //             'https://firebasestorage.googleapis.com/v0/b/campusassistantbd.appspot.com/o/basic_counseling.png?alt=media&token=44aeec92-f2ff-4408-80ab-66f82aa971b4',
      //       }
      //     },
      //   );
      // }),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1080),
            padding: MediaQuery.of(context).size.width > 700
                ? const EdgeInsets.symmetric(
                    horizontal: 100,
                  )
                : const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
            child: Column(
              children: [
                // header
                const HeaderSection(),

                const SizedBox(height: 32),

                // appointment
                appointmentSection(context),

                const SizedBox(height: 32),

                // Training
                const TrainingSection(),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget appointmentSection(BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.pushNamed(context, '/appointment');
    },
    borderRadius: BorderRadius.circular(10),
    child: Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(),
      ),
      child: Column(
        children: [
          Text(
            'Book for counseling services',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.w300,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Get Appointment',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    ),
  );
}
