import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import '/pdf_generator/add_screen.dart';
import '/screen/admin/admin_payment.dart';
import '/screen/auth/login_screen.dart';
import '/screen/auth/register_screen.dart';
import '/screen/profile/profile_screen.dart';
import 'firebase_options.dart';
import 'screen/admin/admin_login_screen.dart';
import 'screen/home/home_screen.dart';
import 'screen/training/training_details.dart';
import 'screen/training/training_payment.dart';

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
        fontFamily: 'Montserrat-Regular',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          titleTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat-Regular',
                fontSize: 18,
              ),
        ),
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
              fontFamily: 'Montserrat-Regular',
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name!);

        // Handle single path segments, e.g., '/basic-counseling'
        if (uri.pathSegments.length == 1) {
          final routeName = uri.pathSegments.first;
          return MaterialPageRoute(
            builder: (context) => TrainingDetail(routeName: routeName),
            settings: settings,
          );
        }

        // Handle nested path segments, e.g., '/basic-counseling-1/payment'
        if (uri.pathSegments.length == 2) {
          final trainingName = uri.pathSegments.first;
          final subRoute = uri.pathSegments[1];

          if (subRoute == 'payment') {
            return MaterialPageRoute(
              builder: (context) => TrainingPayment(routeName: trainingName),
              settings: settings,
            );
          }
        }
        // Return null if no match found
        return null;
      },
      routes: {
        '/': (context) => const HomeScreen(),
        '/admin': (context) => const AdminLoginScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/certificate': (context) => const AddScreen(),
        '/check': (context) => const AdminPayment(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}

//x
class UnknownRouteScreen extends StatelessWidget {
  const UnknownRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unknown Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
          child: const Text('Back to Home'),
        ),
      ),
    );
  }
}
