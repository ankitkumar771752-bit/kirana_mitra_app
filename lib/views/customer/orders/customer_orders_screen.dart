import 'package:flutter/material.dart';

class CustomerOrdersScreen extends StatelessWidget {
  const CustomerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: const Center(
        child: Text('No Orders Placed Yet'),
      ),
    );
  }
}
