import 'package:flutter/material.dart';

class CustomerProductsScreen extends StatelessWidget {
  const CustomerProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: const Center(
        child: Text('Customer Products Catalog'),
      ),
    );
  }
}
