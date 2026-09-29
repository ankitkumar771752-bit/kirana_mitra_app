import 'package:flutter/material.dart';

class DeliveryRequestsScreen extends StatelessWidget {
  const DeliveryRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Requests')),
      body: const Center(child: Text('New Delivery Requests')),
    );
  }
}
