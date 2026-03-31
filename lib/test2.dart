import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // For date formatting

class CreateReminderScreen extends StatefulWidget {
  @override
  _CreateReminderScreenState createState() => _CreateReminderScreenState();
}

class _CreateReminderScreenState extends State<CreateReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _categoryController = TextEditingController();
  final _notesController = TextEditingController();

  List<String> _doses = [];
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isSubmitting = false;

  // Format DateTime to ISO8601 with timezone (e.g., "2025-02-24T08:00:00Z")
  String _formatDateTime(DateTime date, String time) {
    final timeParts = time.split(':');
    final hours = int.parse(timeParts[0]);
    final minutes = int.parse(timeParts[1]);

    final adjustedDate = DateTime(
      date.year, date.month, date.day, hours, minutes,
    );
    return adjustedDate.toUtc().toIso8601String();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final timeStr = "${picked.hour.toString().padLeft(2, '0')}:"
            "${picked.minute.toString().padLeft(2, '0')}:00";
        if (!_doses.contains(timeStr)) {
          _doses.add(timeStr);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Time already added!')),
          );
        }
      });
    }
  }

  Future<void> _submitReminder() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (_startDate == null || _endDate == null) {
      _showSnackbar('Select start and end dates', isError: true);
      return;
    }

    if (_doses.isEmpty) {
      _showSnackbar('Add at least one dose time', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showSnackbar('User not authenticated', isError: true);
        return;
      }

      final idToken = await user.getIdToken();
      const url = 'https://minorproject-yytm.onrender.com/reminder/create';

      // Use first dose time for start_date_time (or adjust as needed)
      final startDateTime = _formatDateTime(_startDate!, _doses.first);
      final endDateTime = _formatDateTime(_endDate!, _doses.first);

      final reminderData = {
        "r_name": _nameController.text.trim(),
        "r_photo": _imageUrlController.text.trim(),
        "r_type": "MEDICINE",
        "category": _categoryController.text.trim(),
        "doses": _doses.map((time) => {"doseTime": time}).toList(),
        "frequency": "DAILY",
        "start_date_time": startDateTime,
        "end_date_time": endDateTime,
        "notes": _notesController.text.trim(),
        "flag": "ACTIVE",
        "status": "NOT_TAKEN",
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": 'Bearer $idToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode(reminderData),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _showSnackbar('Reminder created successfully!', isError: false);
        Navigator.pop(context, true); // Return success
      } else {
        _showSnackbar(
          responseData['message'] ?? 'Failed to create reminder',
          isError: true,
        );
      }
    } on SocketException {
      _showSnackbar('No internet connection', isError: true);
    } catch (e) {
      _showSnackbar('Error: ${e.toString()}', isError: true);
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _showSnackbar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageUrlController.dispose();
    _categoryController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Reminder')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Reminder Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value!.isEmpty ? 'Enter a name' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: 'Image URL (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category (e.g., Tablet, Syrup)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value!.isEmpty ? 'Enter a category' : null,
              ),
              SizedBox(height: 12),
              _DatePickerField(
                label: 'Start Date',
                date: _startDate,
                onTap: () => _selectDate(context, true),
              ),
              SizedBox(height: 12),
              _DatePickerField(
                label: 'End Date',
                date: _endDate,
                onTap: () => _selectDate(context, false),
              ),
              SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text('Dose Times', style: TextStyle(fontSize: 16)),
                      if (_doses.isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text('No times added yet'),
                        ),
                      ..._doses.map((dose) => ListTile(
                        title: Text(dose),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => setState(() => _doses.remove(dose)),
                        ),
                      )),
                      TextButton.icon(
                        icon: Icon(Icons.add),
                        label: Text('Add Dose Time'),
                        onPressed: _selectTime,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Notes (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              SizedBox(height: 20),
              _isSubmitting
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _submitReminder,
                child: Text('Create Reminder'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Reusable date picker field widget
class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const _DatePickerField({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date != null
                  ? DateFormat('yyyy-MM-dd').format(date!)
                  : 'Select $label',
            ),
            Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }
}