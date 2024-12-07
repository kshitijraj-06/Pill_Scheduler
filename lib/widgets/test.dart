import 'package:flutter/material.dart';

class UpcomingMedicationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Upcoming Medications',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Navigate to "View All" page
            },
            child: Text(
              'View All',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          )
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            MedicationCard(
              icon: Icons.medication_outlined,
              name: 'Atorvastatin',
              dosage: '20 mg',
              frequency: 'Daily 2 times',
              time: '14:00 PM',
              remaining: '20 capsules remain',
              course: 'Daily',
            ),
            MedicationCard(
              icon: Icons.medical_services_outlined,
              name: 'Metformin',
              dosage: '500 ml',
              frequency: 'Daily 2 times',
              time: '14:00 PM',
              remaining: '20 capsules remain',
              course: 'Daily',
            ),
            MedicationCard(
              icon: Icons.medication,
              name: 'Clopidogrel',
              dosage: '75 mg',
              frequency: 'Daily 2 times',
              time: '14:00 PM',
              remaining: '20 capsules remain', course: 'Daily',
            ),
          ],
        ),
      ),
    );
  }
}

class MedicationCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final String dosage;
  final String frequency;
  final String time;
  final String remaining;
  final String course;

  const MedicationCard({
    required this.icon,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.time,
    required this.remaining,
    required this.course
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blue[50],
              child: Icon(icon, color: Colors.blue, size: 28),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$name - $dosage',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Daily $frequency Times',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(
                        time,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.inventory_2, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(
                        '$remaining Capsule Remains',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}