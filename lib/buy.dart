import 'package:flutter/material.dart';

class BuyPage extends StatelessWidget {
  const BuyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Set the app bar color to green
        title: const Text(
          'Buy', // App bar title
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
        child: Text('Buy Page Content'), // Example content for the body
      ),
    );
  }
}
