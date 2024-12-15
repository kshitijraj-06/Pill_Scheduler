import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.pushNamed(context, '/chatbot');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/profile');
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pill Scheduler',
        style: GoogleFonts.abyssinicaSil()),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020),
            lastDay: DateTime.utc(2030),
            focusedDay: DateTime.now(),
            calendarStyle: CalendarStyle(
              todayDecoration:
              BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
              selectedDecoration:
              BoxDecoration(color: Colors.green, shape: BoxShape.circle),
            ),
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) => ListTile(
                leading: Icon(Icons.medication),
                title: Text('Medication ${index + 1}'),
                subtitle: Text('Dosage: 1 pill, Time: 8:00 AM'),
                onTap: () =>
                    Navigator.pushNamed(context, '/medication_details'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, '/add_medicine'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chatbot'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
