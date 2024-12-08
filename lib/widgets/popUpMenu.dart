import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add new Reminders',
            style: GoogleFonts.lexendDeca(textStyle: TextStyle(fontSize: 20)),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/medform');
            },
            child: Card(
              color: Colors.white,
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  gapPadding: 3,
                  borderSide: BorderSide(color: Colors.grey.shade400)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Icon(
                        Icons.emergency,
                        size: 30,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Medication',
                          style: GoogleFonts.lexendDeca(
                              textStyle: TextStyle(fontSize: 15)),
                        ),
                        Text(
                          'Name and Dose',
                          style: GoogleFonts.lexendDeca(
                              textStyle:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            color: Colors.white,
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                gapPadding: 3,
                borderSide: BorderSide(color: Colors.grey.shade400)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Icon(
                      Icons.medication_liquid,
                      size: 30,
                      color: Colors.yellow,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Insulin',
                        style: GoogleFonts.lexendDeca(
                            textStyle: TextStyle(fontSize: 15)),
                      ),
                      Text(
                        'Fast or Long Acting Dose',
                        style: GoogleFonts.lexendDeca(
                            textStyle:
                            TextStyle(fontSize: 12, color: Colors.grey)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            color: Colors.white,
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                gapPadding: 3,
                borderSide: BorderSide(color: Colors.grey.shade400)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Icon(
                      Icons.monitor_heart,
                      size: 30,
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Heart Rate',
                        style: GoogleFonts.lexendDeca(
                            textStyle: TextStyle(fontSize: 15)),
                      ),
                      Text(
                        'Fast or Long Acting Dose',
                        style: GoogleFonts.lexendDeca(
                            textStyle:
                            TextStyle(fontSize: 12, color: Colors.grey)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            color: Colors.white,
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                gapPadding: 3,
                borderSide: BorderSide(color: Colors.grey.shade400)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Icon(
                      Icons.bloodtype,
                      size: 30,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Blood Pressure',
                        style: GoogleFonts.lexendDeca(
                            textStyle: TextStyle(fontSize: 15)),
                      ),
                      Text(
                        'Fast or Long Acting Dose',
                        style: GoogleFonts.lexendDeca(
                            textStyle:
                            TextStyle(fontSize: 12, color: Colors.grey)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
