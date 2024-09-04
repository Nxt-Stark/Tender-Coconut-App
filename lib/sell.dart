import 'package:flutter/material.dart';

class SellPage extends StatelessWidget {
  const SellPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Set the app bar color to green
        title: const Text(
          'Sell', // App bar title
          style: TextStyle(
            color: Colors.white, // Title color
            fontWeight: FontWeight.bold, // Make title bold
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Arrow color
        ),
      ),
      body: const Center(
        child: Text('Sell Page Content'), // Example content for the body
      ),
    );
  }
}
