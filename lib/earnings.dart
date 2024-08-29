import 'package:flutter/material.dart';

class EarningsPage extends StatelessWidget {
  const EarningsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Earnings'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: Center(
        child: const Text('Earnings Page Content'),
      ),
    );
  }
}
