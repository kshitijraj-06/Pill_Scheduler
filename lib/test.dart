import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pillscheduler/profile.dart';


class ReminderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ReminderScreen(),
    );
  }
}

class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  List<dynamic> reminders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getIdToken().then((idToken) {
      if (idToken != null) {
        fetchReminders(idToken);
      }
    }).catchError((error) {
      print('Error fetching ID token: $error');
    });
  }


  Future<void> fetchReminders(String idToken) async {
    const String url = 'https://minorproject-yytm.onrender.com/reminder/fetch/'; // Replace with your API endpoint
    try {
      final response = await http.get(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $idToken'
        },);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          reminders = data['data'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load reminders');
      }
    } catch (e) {
      print('Error fetching reminders: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String?> getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final idToken = await user.getIdToken(true);
      return idToken;
    } else {
      throw Exception('No user is currently logged in.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reminders')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          final reminder = reminders[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: reminder['r_photo'] != null
                  ? Image.network(reminder['r_photo'], width: 50, height: 50)
                  : Icon(Icons.medical_services),
              title: Text(reminder['r_name'] ?? 'No Name'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Type: ${reminder['r_type']}'),
                  Text('Category: ${reminder['category']}'),
                  Text('Frequency: ${reminder['frequency']}'),
                  Text('Status: ${reminder['status']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
