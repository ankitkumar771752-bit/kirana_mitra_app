import 'package:flutter/material.dart';

class StoreSalesScreen extends StatelessWidget {
  const StoreSalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Store Sales')),
      body: const Center(child: Text('Sales Reports & Analytics')),
    );
  }
}
