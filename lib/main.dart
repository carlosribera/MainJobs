import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:main_jobs/screens/auth/forget_pass.dart';
import 'package:main_jobs/screens/auth/login.dart';
import 'package:main_jobs/screens/auth/register.dart';
import 'package:main_jobs/screens/home_screen.dart';

// To Initialize Firebase in the main.dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _firebaseInitialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Text('An error occured'),
                ),
              ),
            );
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(primaryColor: Colors.transparent),
            home: const LoginScreen(),
            //To Navigator between pages
            routes: {
              FetchScreen.routeName: (ctx) => const FetchScreen(),
              RegisterScreen.routeName: (ctx) => const RegisterScreen(),
              LoginScreen.routeName: (ctx) => const LoginScreen(),
              ForgetPasswordScreen.routeName: (ctx) =>
                  const ForgetPasswordScreen(),
            },
          );
        });
  }
}
