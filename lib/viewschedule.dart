import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For date formatting

class ViewSchedulePage extends StatelessWidget {
  final CollectionReference _schedulesRef =
      FirebaseFirestore.instance.collection('schedules');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Schedule'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          fontFamily: 'NunitoSans',
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder(
          stream: _schedulesRef.where('status', isEqualTo: false).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LinearProgressIndicator(
                  color: Colors.green,
                ),
              );
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error fetching data'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No schedules available'));
            }

            final schedules = snapshot.data!.docs;

            return ListView.builder(
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final data = schedules[index].data() as Map<String, dynamic>;

                // Convert 'date' and 'time' fields to DateTime
                final DateTime date = _convertToDateTime(data['date']);

                // Format date and time
                final String formattedDate =
                    DateFormat('dd-MM-yyyy').format(date);

                return _buildScheduleContainer(
                  context: context,
                  date: formattedDate,
                  time: data['time'] ?? '',
                  name: data['name'] ?? '',
                  location: data['location'] ?? '',
                  mobile: data['mobile'] ?? '',
                  day: data['day'] ?? '',
                  documentId: schedules[index].id,
                );
              },
            );
          },
        ),
      ),
    );
  }

  DateTime _convertToDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  Widget _buildScheduleContainer({
    required BuildContext context,
    required String date,
    required String time,
    required String name,
    required String location,
    required String mobile,
    required String day,
    required String documentId,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildScheduleRow(
            date: date,
            time: time,
            name: name,
            location: location,
            mobile: mobile,
            day: day,
          ),
          const SizedBox(height: 16.0),
          _buildButtonsRow(context, documentId),
        ],
      ),
    );
  }

  Widget _buildScheduleRow({
    required String date,
    required String time,
    required String name,
    required String location,
    required String mobile,
    required String day,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$date  -  $time',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '$name\n$location\n$mobile',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 63, 145, 66),
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              day,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Icon(
                Icons.call_rounded,
                color: Colors.white,
                size: 60.0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButtonsRow(BuildContext context, String documentId) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => _showRemoveConfirmation(context, documentId),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'NunitoSans',
              ),
            ),
            child: const Text('Remove ⚠️'),
          ),
        ),
      ],
    );
  }

  void _showRemoveConfirmation(BuildContext context, String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Schedule'),
          titleTextStyle: const TextStyle(
            color: Colors.red,
            fontSize: 24,
            fontFamily: 'NunitoSans',
            fontWeight: FontWeight.bold,
          ),
          content: const Text('Do you really want to remove this schedule?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _removeSchedule(context, documentId);
              },
              child: const Text(
                'Remove',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _removeSchedule(BuildContext context, String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('schedules')
          .doc(documentId)
          .delete();

      // Optionally, show a success message if needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Schedule removed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Show an error message if needed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            titleTextStyle: const TextStyle(
              color: Colors.red,
              fontSize: 24,
              fontFamily: 'NunitoSans',
              fontWeight: FontWeight.bold,
            ),
            content: const Text('Failed to remove the schedule.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
