import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pillscheduler/loginpage.dart';
import 'package:pillscheduler/profile.dart';
import 'package:pillscheduler/settings.dart';
import 'AddReminder/addmedform.dart';
import 'Chat/chatscreen.dart';
import 'dashboard.dart';
import 'meddetails.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(PillSchedulerApp());
}

class PillSchedulerApp extends StatelessWidget {
  const PillSchedulerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pill Scheduler',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AuthScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/add_medicine': (context) => AddMedicineScreen(),
        '/medication_details': (context) => MedicationDetailsScreen(),
        '/chatbot': (context) => ChatbotScreen(),
        '/settings': (context) => SettingsScreen(),
        '/profile' : (context) => ProfileScreen(),
        '/home' : (context) => HomeScreen(),
      },
    );
  }
}


