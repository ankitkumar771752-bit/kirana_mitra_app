import 'package:flutter/material.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Platform Orders')),
      body: const Center(child: Text('Platform-wide Orders Monitoring')),
    );
  }
}
