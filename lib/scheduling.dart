import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SchedulingPage extends StatefulWidget {
  const SchedulingPage({Key? key}) : super(key: key);

  @override
  _SchedulingPageState createState() => _SchedulingPageState();
}

class _SchedulingPageState extends State<SchedulingPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 0);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _locationFocusNode = FocusNode();
  final FocusNode _mobileFocusNode = FocusNode();
  final FocusNode _dateFocusNode = FocusNode();
  final FocusNode _timeFocusNode = FocusNode();

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  String _formatTime(TimeOfDay time) {
    return "${time.format(context)}";
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Exit'),
              titleTextStyle: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 24,
                fontFamily: 'NunitoSans',
              ),
              content: const Text('Are you really sure you want to go back?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<void> _saveSchedule() async {
    if (!_formKey.currentState!.validate()) {
      // If the form is not valid, show a snackbar or alert
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }

    _nameFocusNode.unfocus();
    _locationFocusNode.unfocus();
    _mobileFocusNode.unfocus();
    _dateFocusNode.unfocus();
    _timeFocusNode.unfocus();

    String docId =
        '${selectedDate.toIso8601String()}_${selectedTime.format(context)}';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color.fromARGB(0, 0, 0, 0),
          child: Center(
            child: Transform.scale(
              scale: 4.0,
              child: CupertinoActivityIndicator(
                animating: true,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
        );
      },
    );

    try {
      await Future.delayed(Duration(seconds: 0));

      final querySnapshot = await FirebaseFirestore.instance
          .collection('schedules')
          .where('date', isEqualTo: selectedDate)
          .where('time', isEqualTo: selectedTime.format(context))
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Time Conflict'),
            titleTextStyle: const TextStyle(
                fontFamily: 'NunitoSans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red),
            content: const Text(
                'A schedule already exists for this date and time. Please choose a different time.'),
            contentTextStyle: const TextStyle(
              fontFamily: 'NunitoSans',
              color: Colors.black,
              fontSize: 16,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('schedules').doc(docId).set({
        'name': _nameController.text,
        'location': _locationController.text,
        'mobile': _mobileController.text,
        'date': selectedDate,
        'time': selectedTime.format(context),
        'status': false, // Add this line to set the default status
      });

      Navigator.of(context).pop();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          titleTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
              fontSize: 20,
              fontFamily: 'NunitoSans'),
          content: Text(
              'Successfully updated schedule for ${_formatDate(selectedDate)} at ${_formatTime(selectedTime)}.'),
          contentTextStyle: const TextStyle(
              color: Colors.black, fontSize: 16, fontFamily: 'NunitoSans'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _nameController.clear();
                _locationController.clear();
                _mobileController.clear();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving schedule: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _showExitConfirmationDialog(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create new Schedule'),
          backgroundColor: const Color(0xFF4CAF50),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'NunitoSans',
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 20),
                FractionallySizedBox(
                  widthFactor: 0.85,
                  child: TextFormField(
                    controller: _nameController,
                    focusNode: _nameFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                FractionallySizedBox(
                  widthFactor: 0.85,
                  child: TextFormField(
                    controller: _locationController,
                    focusNode: _locationFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Location',
                      labelStyle: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                FractionallySizedBox(
                  widthFactor: 0.85,
                  child: TextFormField(
                    controller: _mobileController,
                    focusNode: _mobileFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Mobile',
                      labelStyle: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mobile number';
                      } else if (value.length != 10) {
                        return 'Mobile number must be 10 digits';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                FractionallySizedBox(
                  widthFactor: 0.85,
                  child: TextFormField(
                    controller:
                        TextEditingController(text: _formatDate(selectedDate)),
                    focusNode: _dateFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      labelStyle: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(),
                      hintText: _formatDate(selectedDate),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.calendar_today_rounded,
                          color: Colors.green,
                        ),
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              selectedDate = pickedDate;
                            });
                          }
                        },
                      ),
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.datetime,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                ),
                const SizedBox(height: 20),
                FractionallySizedBox(
                  widthFactor: 0.85,
                  child: TextFormField(
                    controller:
                        TextEditingController(text: _formatTime(selectedTime)),
                    focusNode: _timeFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Time',
                      labelStyle: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(),
                      hintText: _formatTime(selectedTime),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.green,
                        ),
                        onPressed: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                          );
                          if (pickedTime != null) {
                            setState(() {
                              selectedTime = pickedTime;
                            });
                          }
                        },
                      ),
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.datetime,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.80,
                    child: ElevatedButton(
                      onPressed: _saveSchedule,
                      child: const Text('Save'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _locationFocusNode.dispose();
    _mobileFocusNode.dispose();
    _dateFocusNode.dispose();
    _timeFocusNode.dispose();
    super.dispose();
  }
}
