import 'package:flutter/material.dart';
import 'package:laughterclub/screen/training.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //
            Container(
              height: 450,
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
                  color:
                      Colors.black.withOpacity(0.4), // Adjust opacity as needed
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        "Laughter Club".toUpperCase(),
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                    const SizedBox(height: 10), // Add spacing between texts
                    Text(
                      "University of Chittagong",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            //
            Center(
              child: Container(
                  constraints: const BoxConstraints(maxWidth: 1080),
                  padding: MediaQuery.of(context).size.width > 600
                      ? const EdgeInsets.symmetric(
                          horizontal: 100,
                        )
                      : const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                  child: const Training()),
            ),
          ],
        ),
      ),
    );
  }
}
