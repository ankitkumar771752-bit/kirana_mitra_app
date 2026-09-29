import 'package:flutter/material.dart';

class StoreProductsScreen extends StatelessWidget {
  const StoreProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Store Products')),
      body: const Center(child: Text('Manage Store Products')),
    );
  }
}
