import 'package:flutter/material.dart';

class AdminDeliveryScreen extends StatelessWidget {
  const AdminDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Delivery Partners')),
      body: const Center(child: Text('Delivery Partner Management')),
    );
  }
}
