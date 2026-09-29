import 'package:flutter/material.dart';

class DeliveryEarningsScreen extends StatelessWidget {
  const DeliveryEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Earnings')),
      body: const Center(child: Text('Delivery Partner Earnings')),
    );
  }
}
