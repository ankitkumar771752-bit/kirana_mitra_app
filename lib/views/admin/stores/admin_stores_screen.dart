import 'package:flutter/material.dart';

class AdminStoresScreen extends StatelessWidget {
  const AdminStoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Stores')),
      body: const Center(child: Text('Stores Approval & List')),
    );
  }
}
