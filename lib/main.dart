import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:laughterclub/pdf_generator/add_screen.dart';
import 'package:laughterclub/screen/login_screen.dart';
import 'package:laughterclub/screen/profile_screen.dart';
import 'package:laughterclub/screen/register_screen.dart';

import '/screen/admin_login_screen.dart';
import 'firebase_options.dart';
import 'screen/home_screen.dart';
import 'screen/submit_page.dart';
import 'screen/training_details.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laughter Club',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: const Size(48, 48),
            // backgroundColor: Colors.amberAccent,
            elevation: 2,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/admin': (context) => const AdminLoginScreen(),
        '/add': (context) => const AddScreen(),
        // '/payment': (context) => const PaymentScreen(),
        // '/member': (context) => const TrainingMemberScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/basic-counseling': (context) => const TrainingDetails(index: 0),
        '/advanced-counseling': (context) => const TrainingDetails(index: 1),
        '/cbt': (context) => const TrainingDetails(index: 2),
        '/submit': (context) => const SubmitPage(),
      },
    );
  }
}

//
// email
// "rezoana.shanta25@gmail.com"
// (string)
//
// institute
// "University of Chittagong "
// (string)
//
// mobileNo
// "01308599298"
// (string)
//
// name
// "Rezoana Parveen Shanta"
// (string)
//
//
// payment
// (map)
//
// amount
// "2000"
// (string)
//
// mobile
// "01308599298"
// (string)
//
// status
// "Completed"
// (string)
//
// transactionID
// "BEM3KTRKKH"
// (string)
//
// timestamp
// May 22, 2024 at 1:45:43 AM UTC+6
// (timestamp)
//
// training
// "Basic Counseling"
