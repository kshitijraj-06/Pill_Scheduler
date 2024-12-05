import 'package:flutter/material.dart';
import 'package:pillscheduler/dashboard.dart';
import 'package:pillscheduler/landingpage.dart';
import 'package:pillscheduler/loginpage.dart';

void main() {
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
      },
    );
  }
}
