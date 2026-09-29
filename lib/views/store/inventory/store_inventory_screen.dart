import 'package:flutter/material.dart';

class StoreInventoryScreen extends StatelessWidget {
  const StoreInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Store Inventory')),
      body: const Center(child: Text('Inventory Stock Management')),
    );
  }
}
