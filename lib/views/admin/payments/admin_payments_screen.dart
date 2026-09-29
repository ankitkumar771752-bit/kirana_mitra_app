import 'package:flutter/material.dart';

class AdminPaymentsScreen extends StatelessWidget {
  const AdminPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payments & Transactions')),
      body: const Center(child: Text('Financial Transactions & Payouts')),
    );
  }
}
