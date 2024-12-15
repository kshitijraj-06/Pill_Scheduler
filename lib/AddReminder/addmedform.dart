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
  final _primaryColor = Color(0xFF4F46E5);
  final _accentColor = Color(0xFF6366F1);
  final _cardElevation = 2.0;
  final _borderRadius = 12.0;
  final _inputFillColor = Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Medicine',
            style: GoogleFonts.abyssinicaSil(
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
              )
            ),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: _primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.grey.shade50,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildSectionHeader(
                    icon: Icons.medical_services,
                    title: 'Medicine Details',
                    subtitle: 'Basic information about your medication'),
                _buildBasicInfoCard(),
                SizedBox(height: 24),
                _buildSectionHeader(
                    icon: Icons.schedule,
                    title: 'Dosage Schedule',
                    subtitle: 'Set your medication routine'),
                _buildScheduleCard(),
                SizedBox(height: 32),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required IconData icon, required String title, required String subtitle}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: _primaryColor),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  )),
              Text(subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    return Card(
      elevation: _cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInputField(
              controller: _nameController,
              label: 'Medicine Name',
              icon: Icons.medication_outlined,
              validator: (value) => value!.isEmpty ? 'Required field' : null,
            ),
            SizedBox(height: 16),
            _buildInputField(
              controller: _photoController,
              label: 'Image URL (Optional)',
              icon: Icons.image_outlined,
              trailing: _photoController.text.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  _photoController.text,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              )
                  : null,
            ),
            SizedBox(height: 16),
            _buildDropdown(
              value: _selectedType,
              items: ['MEDICINE', 'SUPPLEMENT', 'OTHER'],
              label: 'Type',
              icon: Icons.category_outlined,
              onChanged: (value) => setState(() => _selectedType = value!),
            ),
            SizedBox(height: 16),
            _buildDropdown(
              value: _selectedCategory,
              items: ['Tablet', 'Syrup', 'Capsule', 'Injection'],
              label: 'Category',
              icon: Icons.inventory_2_outlined,
              onChanged: (value) => setState(() => _selectedCategory = value!),
            ),
            SizedBox(height: 16),
            _buildInputField(
              controller: _notesController,
              label: 'Additional Notes',
              icon: Icons.note_alt_outlined,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard() {
    return Card(
      elevation: _cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDropdown(
              value: _selectedFrequency,
              items: ['DAILY', 'CUSTOM'],
              label: 'Frequency',
              icon: Icons.repeat_outlined,
              onChanged: (value) => setState(() => _selectedFrequency = value!),
            ),
            if(_selectedFrequency == 'CUSTOM') ...[
              SizedBox(height: 16),
              _buildInputField(
                controller: _daysController,
                label: 'Active Days (e.g., Mon, Wed, Fri)',
                icon: Icons.calendar_today_outlined,
                validator: (value) =>
                value!.isEmpty ? 'Required for custom schedule' : null,
              ),
            ],
            SizedBox(height: 16),
            _buildTimeSelector(),
            SizedBox(height: 16),
            _buildDateRangeSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int? maxLines,
    Widget? trailing,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines ?? 1,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey.shade600),
        suffixIcon: trailing != null ? Padding(
          padding: EdgeInsets.only(right: 12),
          child: trailing,
        ) : null,
        filled: true,
        fillColor: _inputFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
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
    return Container(
      decoration: BoxDecoration(
        color: _inputFillColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((item) => DropdownMenuItem(
          value: item,
          child: Text(item),
        )).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.grey.shade600),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
        ),
        dropdownColor: Colors.white,
        icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
      ),
    );
  }

  Widget _buildTimeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dosage Times',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._selectedTimes.map((time) => Container(
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _primaryColor.withOpacity(0.3)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat.Hm().format(DateTime(2023, 1, 1, time.hour, time.minute)),
                    ),
                    SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => setState(
                              () => _selectedTimes.removeWhere((t) => t == time)),
                      child: Icon(Icons.close, size: 16, color: _primaryColor),
                    ),
                  ],
                ),
              ),
            )),
            _buildAddButton(
              label: 'Add Time',
              onPressed: _selectTime,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateRangeSelector() {
    return Row(
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
    );
  }

  Widget _buildDateButton({required String label, required DateTime date, required bool isStart}) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      onPressed: () => _selectDateTime(isStart),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: Colors.grey.shade600,
              ),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            DateFormat('MMM dd, yyyy').format(date),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          Text(
            DateFormat('hh:mm a').format(date),
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton({required String label, required VoidCallback onPressed}) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        backgroundColor: _primaryColor.withOpacity(0.05),
        side: BorderSide(color: _primaryColor.withOpacity(0.3)),
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
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)),
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        onPressed: _handleSubmit,
        child: Text('Save Reminder',
            style: GoogleFonts.abyssinicaSil(
              textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            )
            ),),
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
          ),
          dialogBackgroundColor: Colors.white,
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
          ),
          dialogBackgroundColor: Colors.white,
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
            ),
            dialogBackgroundColor: Colors.white,
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
        "doses": _selectedTimes.map((time) =>
        {"doseTime": "${time.hour.toString().padLeft(2,'0')}:${time.minute.toString().padLeft(2,'0')}:00"}).toList(),
        "frequency": _selectedFrequency,
        "days": _selectedFrequency == 'CUSTOM' ? _daysController.text : null,
        "start_date_time": _startDate.toIso8601String(),
        "end_date_time": _endDate.toIso8601String(),
        "notes": _notesController.text,
      };

      final response = await http.post(
        Uri.parse('http://172.28.0.1:8080/reminder/create'),
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