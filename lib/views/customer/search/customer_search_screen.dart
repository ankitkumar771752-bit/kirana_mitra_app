import 'package:flutter/material.dart';

class CustomerSearchScreen extends StatelessWidget {
  const CustomerSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Products')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search groceries, vegetables...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
    );
  }
}
