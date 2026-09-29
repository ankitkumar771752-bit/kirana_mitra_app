import 'package:flutter/material.dart';

class StoreOrdersScreen extends StatelessWidget {
  const StoreOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Store Orders')),
      body: const Center(child: Text('Customer Orders for Store')),
    );
  }
}
