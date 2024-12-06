import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pillscheduler/dashboard.dart';
import 'package:pillscheduler/landingpage.dart';
import 'package:pillscheduler/loginpage.dart';
import 'package:pillscheduler/widgets/calendercard.dart';
import 'package:pillscheduler/widgets/test2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LandingPage(),
      routes: {
        '/landingpage2' : (context) => LandingPage2(),
        '/login' : (context) => LoginPage(),
        'dashboard' : (context) => DashBoard(),
        '/cc' : (context) => VerticalTimeline(),
      },
    );
  }
}
