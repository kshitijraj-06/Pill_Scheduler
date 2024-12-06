import 'package:flutter/material.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pillscheduler/widgets/calendercard.dart';
import 'package:pillscheduler/widgets/test.dart';

class DashBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'MediAlert',
          style: GoogleFonts.lexendDeca(
              textStyle: TextStyle(
                  color: Colors.green.shade400,
                  fontWeight: FontWeight.bold,
                  fontSize: 30)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height/2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: EventCalendar(
                  calendarOptions: CalendarOptions(
                      viewType: ViewType.DAILY,
                      headerMonthElevation: 0,
                      headerMonthBackColor: Colors.white,
                      headerMonthShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  calendarType: CalendarType.GREGORIAN,
                  calendarLanguage: 'en',
                  events: [
                    Event(
                      child: MedicationCard(
                        icon: Icons.medication_outlined,
                        name: 'Medical',
                        dosage: '1 mg',
                        frequency: '2',
                        time: '2:00 PM',
                        remaining: '20',
                        course: 'Daily',
                        iconColor: Colors.black,
                      ),
                      dateTime: CalendarDateTime(
                        year: 2024,
                        month: 12,
                        day: 7,
                        calendarType: CalendarType.GREGORIAN,
                      ),
                    ),
                    Event(
                      child: MedicationCard(
                        icon: Icons.medication_outlined,
                        name: 'Medical',
                        dosage: '1 mg',
                        frequency: '2',
                        time: '2:00 PM',
                        remaining: '20',
                        course: 'Daily',
                        iconColor: Colors.black,
                      ),
                      dateTime: CalendarDateTime(
                        year: 2024,
                        month: 12,
                        day: 7,
                        calendarType: CalendarType.GREGORIAN,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/cc');
              },
              child: Text('Test'),
            )
          ],
        ),
      ),
    );
  }
}
