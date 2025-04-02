import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProfile {
  final String id;
  final String? name;
  final String email;
  final String? photoUrl;
  final String? token;

  UserProfile({
    required this.id,
    this.name,
    required this.email,
    this.photoUrl,
    this.token,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return UserProfile(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      photoUrl: data['photo_url'],
      token: data['id'],
    );
  }
}

class MedicationReminder {
  final String id;
  final String name;
  final String category;
  final List<DoseTime> doses;
  final String frequency;
  final String status;
  final String? notes;
  final String? photoUrl;

  MedicationReminder({
    required this.id,
    required this.name,
    required this.category,
    required this.doses,
    required this.frequency,
    required this.status,
    this.notes,
    this.photoUrl,
  });

  factory MedicationReminder.fromJson(Map<String, dynamic> json) {
    return MedicationReminder(
      id: json['id'].toString(),
      name: json['r_name'],
      category: json['category'],
      doses:
          List<DoseTime>.from(json['doses'].map((x) => DoseTime.fromJson(x))),
      frequency: json['frequency'],
      status: json['status'],
      notes: json['notes'],
      photoUrl: json['r_photo'],
    );
  }
}

class DoseTime {
  final String id;
  final String time;

  DoseTime({
    required this.id,
    required this.time,
  });

  factory DoseTime.fromJson(Map<String, dynamic> json) {
    final time = json['doseTime'];
    return DoseTime(
      id: json['id'].toString(),
      time: time is String ? time : formatTimeFromObject(time),
    );
  }

  static String formatTimeFromObject(dynamic timeObj) {
    if (timeObj is Map) {
      final hour = timeObj['hour'].toString().padLeft(2, '0');
      final minute = timeObj['minute'].toString().padLeft(2, '0');
      return '$hour:$minute';
    }
    return '00:00';
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<UserProfile>? profileFuture;
  Future<List<MedicationReminder>>? medicationsFuture;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<String?> getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }

  void loadUserData() async {
    try {
      final token = await getIdToken();
      if (token != null) {
        setState(() {
          profileFuture = fetchUserProfile(token);
          medicationsFuture = fetchMedications(token);
        });
      }
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future<UserProfile> fetchUserProfile(String idToken) async {
    final response = await http.get(
      Uri.parse('https://minorproject-yytm.onrender.com/user/fetch'),
      headers: {'Authorization': 'Bearer $idToken'},
    );

    if (response.statusCode == 200) {
      print(idToken);
      return UserProfile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<List<MedicationReminder>> fetchMedications(String idToken) async {
    final response = await http.get(
      Uri.parse('https://minorproject-yytm.onrender.com/reminder/fetch'),
      headers: {'Authorization': 'Bearer $idToken'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => MedicationReminder.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load medications');
    }
  }

  Widget _buildProfileHeader(UserProfile profile, int medicationCount) {
    return FutureBuilder(
        future: _countActiveMedications(),
        builder: (context, snapshot) {
          final activeCount = snapshot.data ?? '0';

          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height *0.38,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30)),
                ),
              ),
              Positioned(
                top: 50,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 46,
                    backgroundImage: profile.photoUrl != null
                        ? NetworkImage(profile.photoUrl!)
                        : NetworkImage(
                            'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'),
                  ),
                ),
              ),
              Positioned(
                top: 170,
                child: Text(
                  profile.name ?? 'No Name',
                  style: TextStyle(
                    fontFamily: 'MonaSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                top: 210,
                child: Text(
                  profile.email,
                  style: TextStyle(
                    fontFamily: 'MonaSans',
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 228.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                            'Medications', medicationCount.toString()),
                        _buildStatItem('Active', activeCount),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }


  Future<String> _countActiveMedications() async {
    if (medicationsFuture == null) return '0';
    final meds = await medicationsFuture!;
    return meds.where((m) => m.status == 'ACTIVE').length.toString();
  }

  Widget _buildStatItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildMedicationsSection(List<MedicationReminder> medications) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'Your Medications',
                style: TextStyle(
                  fontFamily: 'MonaSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: medications.length,
                itemBuilder: (context, index) =>
                    _buildMedicationItem(medications[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationItem(MedicationReminder medication) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _getStatusColor(medication.status).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.medical_services,
                color: _getStatusColor(medication.status),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medication.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${medication.category} • ${medication.frequency}',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 4),
                  Text(
                    medication.status,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  Wrap(
                    spacing: 8,
                    children: medication.doses
                        .map((dose) => Chip(
                              label: Text(dose.time),
                              backgroundColor: Colors.purple.shade50,
                              labelStyle: TextStyle(
                                color: Colors.purple.shade800,
                                fontSize: 12,
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ACTIVE':
        return Colors.green;
      case 'TAKEN':
        return Colors.blue;
      case 'MISSED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',
            style: TextStyle(fontFamily: 'MonaSans', color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/update'),
          )
        ],
      ),
      body: FutureBuilder<UserProfile>(
        future: profileFuture,
        builder: (context, profileSnapshot) {
          if (profileSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (profileSnapshot.hasError) {
            return Center(child: Text('Error loading profile'));
          }

          if (!profileSnapshot.hasData) {
            return Center(child: Text('No profile data available'));
          }

          final profile = profileSnapshot.data!;

          return FutureBuilder<List<MedicationReminder>>(
            future: medicationsFuture,
            builder: (context, medsSnapshot) {
              final medications = medsSnapshot.data ?? [];

              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue.shade50, Colors.purple.shade50],
                  ),
                ),
                child: Column(
                  children: [
                    _buildProfileHeader(profile, medications.length),
                    SizedBox(height: 20,),
                    _buildMedicationsSection(medications),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
