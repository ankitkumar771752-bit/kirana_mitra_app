import 'package:flutter/material.dart';

class CustomerCheckoutScreen extends StatelessWidget {
  const CustomerCheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: const Center(
        child: Text('Checkout Screen'),
      ),
    );
  }
}
