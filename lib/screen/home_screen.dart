import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laughterclub/screen/training.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigator.pushNamed(context, '/');
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/logo.png',
                                height: 32,
                                width: 32,
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Laughter Club',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                          fontWeight: FontWeight.w800,
                                          height: 1.4,
                                        ),
                                  ),
                                  Text(
                                    'University of Chittagong',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(
                                          height: 1.2,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0, minimumSize: const Size(42, 42)),
                          onPressed: () {
                            if (FirebaseAuth.instance.currentUser == null) {
                              Navigator.pushNamed(
                                context,
                                '/login',
                                arguments: '/',
                              );
                            } else {
                              Navigator.pushNamed(
                                context,
                                '/profile',
                              );
                            }
                          },
                          child: (FirebaseAuth.instance.currentUser == null)
                              ? const Text('Login')
                              : const Text('Profile'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  //
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: MediaQuery.of(context).size.width < 400
                          ? MediaQuery.of(context).size.width * .48
                          : MediaQuery.of(context).size.width < 700
                              ? MediaQuery.of(context).size.width * .40
                              : MediaQuery.of(context).size.width * .20,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            "assets/lccu.jpeg",
                          ),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black
                              .withOpacity(0.4), // Adjust opacity as needed
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Laughter Club".toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(
                                height: 4), // Add spacing between texts
                            Text(
                              "University of Chittagong",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  //
                  const Training(),
                ],
              )),
        ),
      ),
    );
  }
}
