import 'package:flutter/material.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KiranaMitra - Customer Home')),
      body: const Center(
        child: Text('Customer Home Screen (MVC View)'),
      ),
    );
  }
}
