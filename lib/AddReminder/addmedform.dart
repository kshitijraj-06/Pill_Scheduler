import 'dart:io';
import 'package:intl/intl.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class MedForm extends StatefulWidget {
  @override
  State<MedForm> createState() => _MedFormState();
}

class _MedFormState extends State<MedForm> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  final TextEditingController _medName = TextEditingController();
  final TextEditingController _medDosage = TextEditingController();
  final TextEditingController _medRemains = TextEditingController();
  final TextEditingController _medCategory = TextEditingController();
  final TextEditingController _medNotes = TextEditingController();

  String? _selectedCategory = 'Tablets';
  final List<String> _categories = ['Tablets', 'Syrups', 'Eye Drops', 'Injections'];

  String? _selectedFrequency = 'Daily';
  final List<String> _frequency = ['Daily', 'Alternative', 'Weekly'];

  DateTime? _startDateTime;
  DateTime? _endDateTime;
  List<TimeOfDay?> _dosageTimes = [];



  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _updateDosageFields(int dosage) {
    setState(() {
      _dosageTimes = List.generate(dosage, (_) => null);
    });
  }

  Future<void> _selectDosageTime(BuildContext context, int index) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _dosageTimes[index] = pickedTime;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFCBF8F3), Colors.white])),
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 50, right: 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20,
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              size: 20,
                            )),
                      ),
                      Expanded(
                        child: Text(
                          'Add Medication',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lexendDeca(
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  decoration: TextDecoration.none,
                                  color: Colors.black)),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height,
                      ),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, top: 20, right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Add Image',
                                  style: GoogleFonts.lexendDeca(
                                      textStyle: TextStyle(
                                          fontSize: 19,
                                          decoration: TextDecoration.none,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal)),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '(Optional)',
                                  style: GoogleFonts.lexendDeca(
                                      fontSize: 19,
                                      color: Colors.grey,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            DottedBorder(
                              borderType: BorderType.RRect,
                              //padding: EdgeInsets.all(6),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                child: GestureDetector(
                                  onTap: () {
                                    _pickImage(ImageSource.camera);
                                  },
                                  child: _selectedImage != null
                                      ? Image.file(
                                          _selectedImage!,
                                          height: 250,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          fit: BoxFit.contain,
                                        )
                                      : Container(
                                          height: 200,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: Colors.white,
                                          child: Icon(
                                            Icons.add,
                                            size: 30,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 17,
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  _pickImage(ImageSource.gallery);
                                },
                                child: Text(
                                  'Choose a Photo',
                                  style: GoogleFonts.lexendDeca(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                          decoration: TextDecoration.none,
                                          color: Colors.black)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Medication Name ',
                              style: GoogleFonts.lexendDeca(
                                  textStyle: TextStyle(
                                      fontSize: 19,
                                      decoration: TextDecoration.none,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal)),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            TextField(
                              controller: _medName,
                              decoration: InputDecoration(
                                label: Text('Enter the Medicine Name'),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade100)),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Category',
                                    style: GoogleFonts.lexendDeca(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 19)),
                                  ),
                                ),
                                SizedBox(width: 20,),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Dosage',
                                      style: GoogleFonts.lexendDeca(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 19)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: _selectedCategory,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15),
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade100)
                                        ),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      ),
                                      items: _categories.map((String category) {
                                        return DropdownMenuItem<String>(
                                          value: category,
                                          child: Text(category,
                                          style: GoogleFonts.lexendDeca(
                                            textStyle: TextStyle(
                                             // color: Colors.grey.shade600
                                            )
                                          ),),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedCategory = newValue;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: TextField(
                                        controller: _medDosage,
                                        decoration: InputDecoration(
                                          constraints: BoxConstraints(
                                            maxHeight: 49
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(15),
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade100)
                                          )
                                        ),
                                        onChanged: (value) {
                                          final dosage = int.tryParse(value) ?? 0;
                                          _updateDosageFields(dosage);
                                        },
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(height: 12,),
                            ...List.generate(_dosageTimes.length, (index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Time for Dosage ${index + 1}',
                                    style: GoogleFonts.lexendDeca(
                                      textStyle: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () => _selectDosageTime(context, index),
                                    child: Container(
                                      height: 50,
                                      margin: EdgeInsets.only(bottom: 16),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 12),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        _dosageTimes[index] != null
                                            ? _dosageTimes[index]!.format(context)
                                            : 'Select Time',
                                        style: GoogleFonts.lexendDeca(
                                          textStyle: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Frequency',
                                style: GoogleFonts.lexendDeca(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 19
                                  )
                                ),),
                                SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  value: _selectedFrequency,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade100)
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  items: _frequency.map((String frequency) {
                                    return DropdownMenuItem<String>(
                                      value: frequency,
                                      child: Text(frequency,
                                      style: GoogleFonts.lexendDeca(
                                        //color: Colors.grey.shade600
                                      ),),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedFrequency = newValue;
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text('Start Date and Time',
                                style: GoogleFonts.lexendDeca(
                                  textStyle: TextStyle(
                                    fontSize: 19
                                  )
                                ),),
                                SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () => _selectedDateTime(context, "start"),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey)
                                    ),
                                    child: Padding (
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          _startDateTime != null
                                              ? DateFormat('dd-MM-yyyy - HH:mm').format(_startDateTime!)
                                              : 'Select Start Date & Time',
                                          style: GoogleFonts.lexendDeca(
                                            textStyle: TextStyle(
                                              fontSize: 15
                                            )
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text('End Date and Time',
                                  style: GoogleFonts.lexendDeca(
                                      textStyle: TextStyle(
                                          fontSize: 19
                                      )
                                  ),),
                                SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () => _selectedDateTime(context, "end"),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey)
                                    ),
                                    child: Padding (
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          _endDateTime != null
                                              ? DateFormat('dd-MM-yyyy - HH:mm').format(_endDateTime!)
                                              : 'Select End Date & Time',
                                          style: GoogleFonts.lexendDeca(
                                              textStyle: TextStyle(
                                                  fontSize: 15
                                              )
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text('Notes/Remarks',
                                style: GoogleFonts.lexendDeca(
                                  fontSize: 19,
                                  fontWeight: FontWeight.normal
                                ),),
                                TextField(
                                  controller: _medNotes,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade100
                                      )
                                    )
                                  ),
                                ),
                                SizedBox(height: 10,)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  void _printDateTimes() {
    if (_startDateTime != null) {
      print("Start Date & Time: ${DateFormat('yyyy-MM-dd – HH:mm').format(_startDateTime!)}");
    }
    if (_endDateTime != null) {
      print("End Date & Time: ${DateFormat('yyyy-MM-dd – HH:mm').format(_endDateTime!)}");
    }
  }


  Future<void> _selectedDateTime(BuildContext context, String type) async{
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if(pickedDate!= null) {
      final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now()
      );

      if(pickedTime!= null){
        setState(() {
          final DateTime selectedDateTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute
          );

          if (type == "start") {
            _startDateTime = selectedDateTime;
          } else if (type == "end") {
            _endDateTime = selectedDateTime;
          }
        });
      }
    }
  }

}
