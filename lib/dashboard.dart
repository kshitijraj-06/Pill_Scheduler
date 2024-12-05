import 'package:flutter/material.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:google_fonts/google_fonts.dart';

class DashBoard extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('MediAlert',
        style: GoogleFonts.lexendDeca(
          textStyle: TextStyle(
            color: Colors.green.shade400,
            fontWeight: FontWeight.bold,
              fontSize: 30
          )
        ),),
      ),
      body: EventCalendar(
        calendarType: CalendarType.GREGORIAN,
        calendarLanguage: 'en',
        events: [
          Event(
            child: const Text('Laravel Event'),
            dateTime: CalendarDateTime(
              year: 2024,
              month: 12,
              day: 6,
              calendarType: CalendarType.GREGORIAN,
            ),
          ),
        ],
      ),
    );
  }

}