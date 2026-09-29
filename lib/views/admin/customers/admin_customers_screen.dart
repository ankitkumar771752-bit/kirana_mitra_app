import 'package:flutter/material.dart';

class AdminCustomersScreen extends StatelessWidget {
  const AdminCustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Customers')),
      body: const Center(child: Text('Customer List & Details')),
    );
  }
}
