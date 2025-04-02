import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'meddetails.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<dynamic> _medications = [];
  bool _isLoading = true;
  bool _isRefreshing = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _fetchMedications();
  }

  Future<void> _fetchMedications() async {
    setState(() {
      if(!_isLoading) _isRefreshing = true;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final token = await user.getIdToken();
      final response = await http.get(
        Uri.parse('https://minorproject-yytm.onrender.com/reminder/fetch'),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        setState(() {
          _medications = jsonDecode(response.body)['data'];
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load medications');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isRefreshing = false);
    }
  }

  List<dynamic> _getMedicationsForDay(DateTime day) {
    if (_medications.isEmpty) return [];

    return _medications.where((med) {
      final startDate = DateTime.parse(med['start_date_time']).toLocal();
      final endDate = DateTime.parse(med['end_date_time']).toLocal();
      return day.isAfter(startDate.subtract(const Duration(days: 1))) &&
          day.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.pushNamed(context, '/chatbot');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/profile').then((_) => _fetchMedications());
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Widget _buildMedicationCard(Map<String, dynamic> med) {
    final doses = List<dynamic>.from(med['doses']);
    final taken = med['status'] == 'TAKEN';
    final remaining = med['remaining_doses'] ?? 0;
    final totalDoses = doses.length;

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicineDetailScreen(medication: med),
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFE8F4FF),
                Color(0xFFF5F9FF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.medication,
                            color: Colors.blue.shade800, size: 24),
                      ),
                      SizedBox(width: 12),
                      Text(
                        med['r_name'] ?? 'Medication',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: taken ? Colors.green.shade100 : Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      taken ? 'TAKEN' : 'PENDING',
                      style: TextStyle(
                        color: taken ? Colors.green.shade800 : Colors.orange.shade800,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  _buildInfoItem(Icons.category, med['category']),
                  SizedBox(width: 16),
                  _buildInfoItem(Icons.repeat, med['frequency']),
                  SizedBox(width: 16),
                  _buildInfoItem(Icons.calendar_month,
                      '${DateFormat('MMM dd').format(DateTime.parse(med['start_date_time']))} - '
                          '${DateFormat('MMM dd').format(DateTime.parse(med['end_date_time']))}'
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.schedule, size: 20, color: Colors.blue.shade800),
                  SizedBox(width: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: doses.map<Widget>((dose) {
                          final time = dose['doseTime'];
                          final timeStr = time is String
                              ? time.split(':').sublist(0, 2).join(':')
                              : '${time['hour']}:${time['minute']}';
                          return Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Chip(
                              label: Text(timeStr),
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.blue.shade100),
                              shape: StadiumBorder(),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              if (totalDoses > 0) ...[
                SizedBox(height: 16),
                LinearProgressIndicator(
                  value: (totalDoses - remaining) / totalDoses,
                  backgroundColor: Colors.blue.shade100,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade800),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(10),
                ),
                SizedBox(height: 8),
                Text(
                  '${totalDoses - remaining}/$totalDoses doses taken',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue.shade600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.blue.shade600),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.blue.shade800,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatDoseTime(dynamic time) {
    if (time is String) {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = parts[1];
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour % 12 == 0 ? 12 : hour % 12;
      return '$displayHour:$minute $period';
    }
    return '${time['hour']}:${time['minute']}';
  }

  @override
  Widget build(BuildContext context) {
    final dayMedications = _selectedDay != null
        ? _getMedicationsForDay(_selectedDay!)
        : [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Pill Scheduler', style: GoogleFonts.abyssinicaSil()),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/reminder')
                .then((_) => _refreshIndicatorKey.currentState?.show()),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: LiquidPullToRefresh(
        key: _refreshIndicatorKey,
        onRefresh: _fetchMedications,
        color: Colors.blue.shade100,
        backgroundColor: Colors.white,
        height: 150,
        animSpeedFactor: 2,
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.now().subtract(const Duration(days: 365)),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: _onDaySelected,
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) => setState(() => _calendarFormat = format),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                markersAutoAligned: false,
              ),
              eventLoader: (day) {
                final meds = _getMedicationsForDay(day);
                return meds.isNotEmpty ? [1] : [];
              },
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : dayMedications.isEmpty
                  ? Center(
                child: Text(
                  'No medications scheduled for ${DateFormat('MMM d, yyyy').format(_selectedDay!)}',
                  style: const TextStyle(fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: dayMedications.length,
                itemBuilder: (context, index) {
                  final med = dayMedications[index];
                  return _buildMedicationCard(med);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.pushNamed(context, '/add_medicine');
          _refreshIndicatorKey.currentState?.show();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chatbot'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}