import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalenderCard extends StatefulWidget {
  @override
  State<CalenderCard> createState() => _CalenderCardState();
}

class _CalenderCardState extends State<CalenderCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15),
            child: Text(
              'Name',
              style: GoogleFonts.montserrat(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              ' Daily 2 Time',
              style: GoogleFonts.montserrat(
                  fontSize: 15, fontWeight: FontWeight.normal, color: Colors.grey),
            ),
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0, bottom: 12),
                child: Card(
                  color: Colors.redAccent.shade100,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text('2:00 PM',
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          color: Colors.red.shade900
                      ),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
