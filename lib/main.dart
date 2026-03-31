import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pillscheduler/loginpage.dart';
import 'package:pillscheduler/profile.dart';
import 'package:pillscheduler/services/notification_service.dart';
import 'package:pillscheduler/settings.dart';
import 'package:pillscheduler/test.dart';
import 'package:pillscheduler/test2.dart';
import 'AddReminder/addmedform.dart';
import 'Chat/chatscreen.dart';
import 'dashboard.dart';
import 'meddetails.dart';
import 'signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notificationService = NotificationService();
  await notificationService.initialize();
  await AndroidAlarmManager.initialize();
  await Firebase.initializeApp();
  runApp(PillSchedulerApp());
}

class PillSchedulerApp extends StatelessWidget {
  const PillSchedulerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pill Scheduler',
      theme: ThemeData(primarySwatch: Colors.blue,
      fontFamily: 'MonaSans'),
      home: AuthCheck(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/add_medicine': (context) => AddMedicineScreen(),
        //'/medication_details': (context) => MedicineDetailScreen(medication: {},),
        '/chatbot': (context) => ChatWidget(apiKey: 'AIzaSyAcWJK6fhvBmp0yPNlmNfpIiww0UI-YiMg'),
        '/settings': (context) => SettingsScreen(),
        '/profile' : (context) => ProfileScreen(),
        '/home' : (context) => HomeScreen(),
        '/signup' : (context) => SignupScreen(),
        '/login' : (context) => AuthScreen(),
        '/reminder' : (context) => ReminderScreen(),
        // '/create' : (context) => AddMedicineScreen()
      },
    );
  }
}

class AuthCheck extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream : FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.active){
          if(snapshot.hasData){
            return HomeScreen();
          }else{
            return AuthScreen();
          }
        }
        return Center(child: CircularProgressIndicator());
      }
    );
  }
}

