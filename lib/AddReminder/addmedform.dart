import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddMedicineScreen extends StatefulWidget {
  @override
  _AddMedicineScreenState createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _photoController = TextEditingController();
  final _notesController = TextEditingController();
  final _daysController = TextEditingController();

  List<TimeOfDay> _selectedTimes = [];
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 30));
  String _selectedType = 'MEDICINE';
  String _selectedCategory = 'Tablet';
  String _selectedFrequency = 'DAILY';

  // Design Constants
  final _primaryColor = Colors.black87;
  final _accentColor = Colors.black87;
  final _backgroundColor = Colors.white;
  final _textColor = Colors.black87;
  final _inputBorderColor = Colors.grey.shade300;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Header Background
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_primaryColor, _accentColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Content
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.25),

                // Form Card
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Center(
                          child: Text(
                            'Add New Medicine',
                            style: TextStyle(
                              fontFamily: 'MonaSans',
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: .5,
                            ),
                          ),
                        ),
                        SizedBox(height: 24),

                        // Medicine Name
                        _buildInputField(
                          controller: _nameController,
                          label: 'Medicine Name',
                          icon: Icons.medication,
                          validator: (value) =>
                              value!.isEmpty ? 'Required field' : null,
                        ),
                        SizedBox(height: 16),

                        // Type and Category Row
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdown(
                                value: _selectedType,
                                items: ['MEDICINE', 'SUPPLEMENT', 'OTHER'],
                                label: 'Type',
                                icon: Icons.category,
                                onChanged: (value) =>
                                    setState(() => _selectedType = value!),
                              ),
                            ),
                            SizedBox(width: 14),
                            Expanded(
                              child: _buildDropdown(
                                value: _selectedCategory,
                                items: [
                                  'Tablet',
                                  'Syrup',
                                  'Capsule',
                                  'Injection'
                                ],
                                label: 'Category',
                                icon: Icons.inventory,
                                onChanged: (value) =>
                                    setState(() => _selectedCategory = value!),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Dosage Times
                        Text(
                          'Dosage Times',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _textColor,
                          ),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ..._selectedTimes.map((time) => Chip(
                                  label: Text(
                                    DateFormat.Hm().format(DateTime(
                                        2023, 1, 1, time.hour, time.minute)),
                                  ),
                                  deleteIcon: Icon(Icons.close, size: 16),
                                  onDeleted: () => setState(
                                      () => _selectedTimes.remove(time)),
                                )),
                            _buildAddButton(
                              label: 'Add Time',
                              onPressed: _selectTime,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Date Range
                        Row(
                          children: [
                            Expanded(
                              child: _buildDateButton(
                                label: 'Start Date',
                                date: _startDate,
                                isStart: true,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildDateButton(
                                label: 'End Date',
                                date: _endDate,
                                isStart: false,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Notes
                        _buildInputField(
                          controller: _notesController,
                          label: 'Additional Notes',
                          icon: Icons.note,
                          maxLines: 2,
                        ),
                        SizedBox(height: 24),

                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: Text(
                              'Save Reminder',
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: _handleSubmit,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                //backgroundColor: _primaryColor,
                                //foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),

          // App Bar
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Header Title
          Positioned(
            top: MediaQuery.of(context).size.height * 0.14,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'New Medicine Reminder',
                style: TextStyle(
                  fontFamily: 'MonaSans',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: .5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int? maxLines,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines ?? 1,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: _primaryColor),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _inputBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _inputBorderColor),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required String label,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          overflow: TextOverflow.ellipsis,  // Add overflow handling
          maxLines: 1,                     // Ensure single line
        ),
      )).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: _primaryColor),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _inputBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _inputBorderColor),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        isDense: true,  // Reduces vertical padding
      ),
      dropdownColor: Colors.white,
      icon: Icon(Icons.arrow_drop_down, color: _primaryColor),
      isExpanded: true,  // Critical fix - makes dropdown take available width
      style: TextStyle(
        fontSize: 14,
        color: _textColor,
        overflow: TextOverflow.ellipsis,  // Handle overflow in selected value
      ),
    );
  }

  Widget _buildDateButton(
      {required String label, required DateTime date, required bool isStart}) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(color: _inputBorderColor),
      ),
      onPressed: () => _selectDateTime(isStart),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            DateFormat('MMM dd, yyyy').format(date),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(
      {required String label, required VoidCallback onPressed}) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: _primaryColor),
      ),
      onPressed: onPressed,
      icon: Icon(Icons.add, size: 18, color: _primaryColor),
      label: Text(label, style: TextStyle(color: _primaryColor)),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        onPressed: _handleSubmit,
        child: Text(
          'Save Reminder',
          style: GoogleFonts.abyssinicaSil(
              textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          )),
        ),
      ),
    );
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: _primaryColor,
            onPrimary: Colors.white,
            surface: Colors.white,
          ), dialogTheme: DialogThemeData(backgroundColor: Colors.white),
        ),
        child: child!,
      ),
    );
    if (time != null && !_selectedTimes.contains(time)) {
      setState(() => _selectedTimes.add(time));
    }
  }

  Future<void> _selectDateTime(bool isStart) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: _primaryColor,
            onPrimary: Colors.white,
          ), dialogTheme: DialogThemeData(backgroundColor: Colors.white),
        ),
        child: child!,
      ),
    );

    if (selectedDate != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(isStart ? _startDate : _endDate),
        builder: (context, child) => Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: _primaryColor,
              onPrimary: Colors.white,
            ), dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        ),
      );

      if (selectedTime != null) {
        setState(() {
          final newDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
          if (isStart) {
            _startDate = newDateTime;
            if (_endDate.isBefore(newDateTime)) {
              _endDate = newDateTime.add(Duration(days: 1));
            }
          } else {
            _endDate = newDateTime;
          }
        });
      }
    }
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTimes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add at least one dosage time')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final idToken = await user.getIdToken();
      final medicationData = {
        "r_name": _nameController.text,
        "r_photo": _photoController.text,
        "r_type": _selectedType,
        "category": _selectedCategory,
        "doses": _selectedTimes
            .map((time) => {
                  "doseTime":
                      "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00"
                })
            .toList(),
        "frequency": _selectedFrequency,
        "days": _selectedFrequency == 'CUSTOM' ? _daysController.text : null,
        "start_date_time": _startDate.toIso8601String(),
        "end_date_time": _endDate.toIso8601String(),
        "notes": _notesController.text,
      };

      final response = await http.post(
        Uri.parse('https://minorproject-yytm.onrender.com/reminder/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode(medicationData),
      );
      print(idToken);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reminder saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Failed to save: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving reminder: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _photoController.dispose();
    _daysController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
