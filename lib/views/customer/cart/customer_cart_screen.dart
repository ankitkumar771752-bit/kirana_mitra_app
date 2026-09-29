import 'package:flutter/material.dart';

class CustomerCartScreen extends StatelessWidget {
  const CustomerCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: const Center(
        child: Text('Your Cart is Empty'),
      ),
    );
  }
}
