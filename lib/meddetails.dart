import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicationDetailsScreen extends StatelessWidget {
  final String medicineName = 'Paracetamol'; // Replace with dynamic data
  final String dosage = '1 Pill';
  final List<String> times = ['08:00 AM', '02:00 PM', '08:00 PM'];
  final DateTime startDate = DateTime.now();
  final DateTime endDate = DateTime.now().add(Duration(days: 30));
  final String notes =
      'Take after meals. Avoid alcohol. Consult doctor if fever persists.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medication Details',
            style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue.shade800),
            onPressed: () {
              // Navigate to edit screen
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMedicineHeader(),
              SizedBox(height: 20),
              _buildDosageCard(),
              SizedBox(height: 20),
              _buildScheduleCard(),
              SizedBox(height: 20),
              _buildDateRangeCard(),
              SizedBox(height: 20),
              _buildNotesCard(),
              SizedBox(height: 30),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicineHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.medication, size: 32, color: Colors.blue.shade800),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(medicineName,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade800)),
                  SizedBox(height: 4),
                  Text('Active Medication',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDosageCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dosage Information 💊',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 15),
            Row(
              children: [
                Icon(Icons.medication_liquid, color: Colors.blue.shade800),
                SizedBox(width: 10),
                Text(dosage,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade800)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Intake Schedule ⏰',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 15),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: times
                  .map((time) => Chip(
                label: Text(time),
                backgroundColor: Colors.blue.shade50,
                labelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade800),
              ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangeCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date Range 📅',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildDateItem('Start Date',
                      DateFormat('MMM dd, yyyy').format(startDate)),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildDateItem('End Date',
                      DateFormat('MMM dd, yyyy').format(endDate)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateItem(String title, String date) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          SizedBox(height: 4),
          Text(date,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade800)),
        ],
      ),
    );
  }

  Widget _buildNotesCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Additional Notes 📝',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 15),
            Text(notes,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade800)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.red.shade400),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Delete',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade400)),
            onPressed: () {
              // Handle delete action
            },
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.blue.shade800,
            ),
            child: Text('Edit',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            onPressed: () {
              // Navigate to edit screen
            },
          ),
        ),
      ],
    );
  }
}