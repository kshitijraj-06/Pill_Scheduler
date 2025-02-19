import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MedForm extends StatefulWidget{
  @override
  State<MedForm> createState() => _MedFormState();
}

class _MedFormState extends State<MedForm> {
  final TextEditingController _medName = TextEditingController();
  final TextEditingController _medDosage = TextEditingController();
  final TextEditingController _medRemains = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.cyan, Colors.white]
          )
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, top: 50, right: 18),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios_new,
                        size: 20,)
                    ),
                  ),
                  Expanded(
                    child: Text('Add Medication',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lexendDeca(
                        textStyle: TextStyle(
                        fontSize: 20,
                        decoration: TextDecoration.none,
                        color: Colors.black
                      )
                    ),),
                  )
                ],
              ),
              SizedBox(height: 30,),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Add Image',
                          style: GoogleFonts.lexendDeca(
                            textStyle: TextStyle(
                              fontSize: 19,
                              decoration: TextDecoration.none,
                              color: Colors.black,
                              fontWeight: FontWeight.normal
                            )
                          ),),
                          SizedBox(width: 10,),
                          Text('(Optional)',
                          style: GoogleFonts.lexendDeca(
                            fontSize: 19,
                            color: Colors.grey,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal
                          ),)
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}