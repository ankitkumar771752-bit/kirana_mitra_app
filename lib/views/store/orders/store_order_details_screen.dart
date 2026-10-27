import 'package:flutter/material.dart';

class StoreOrderDetailsScreen extends StatelessWidget {
  final String orderId;
  final String status;
  final String amount;
  final String time;

  const StoreOrderDetailsScreen({
    super.key,
    required this.orderId,
    required this.status,
    required this.amount,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Order Details', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID & Status Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6, spreadRadius: 2)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(orderId, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(time, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(status, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Customer Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6, spreadRadius: 2)],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Customer', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        const Text('Amit Sharma', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 2),
                        const Text('+91 98765 43210', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        const SizedBox(height: 4),
                        const Text('123, Green Park, Gwalior - 474001', style: TextStyle(color: Colors.black54, fontSize: 12)),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening map location...')));
                    },
                    icon: const Icon(Icons.map, size: 16, color: Colors.green),
                    label: const Text('View Map', style: TextStyle(color: Colors.green, fontSize: 12)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Items List
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6, spreadRadius: 2)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Items (5)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const Divider(height: 24),
                  _ItemRow(name: 'Aashirvaad Atta (5kg)', qty: 'x1', price: '₹ 260'),
                  const Divider(height: 16),
                  _ItemRow(name: 'Maggi Noodles (70g)', qty: 'x2', price: '₹ 24'),
                  const Divider(height: 16),
                  _ItemRow(name: 'Tata Salt (1kg)', qty: 'x1', price: '₹ 20'),
                  const Divider(height: 16),
                  _ItemRow(name: 'Fortune Oil (1L)', qty: 'x1', price: '₹ 175'),
                  const Divider(height: 16),
                  _ItemRow(name: 'Dove Soap (100g)', qty: 'x1', price: '₹ 60'),
                  const Divider(height: 24),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Item Total', style: TextStyle(color: Colors.grey)),
                      Text('₹ 539', style: TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Delivery Charges', style: TextStyle(color: Colors.grey)),
                      Text('₹ 20', style: TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Discount', style: TextStyle(color: Colors.green)),
                      Text('(-) ₹ 60', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.green)),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Accept / Reject Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order Rejected'), backgroundColor: Colors.red));
                      Navigator.pop(context);
                    },
                    child: const Text('Reject', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order Accepted! Processing started.'), backgroundColor: Colors.green));
                      Navigator.pop(context);
                    },
                    child: const Text('Accept', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final String name;
  final String qty;
  final String price;

  const _ItemRow({required this.name, required this.qty, required this.price});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.shopping_bag_outlined, size: 18, color: Colors.green),
            const SizedBox(width: 10),
            Text(name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          ],
        ),
        Row(
          children: [
            Text(qty, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(width: 16),
            Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ],
    );
  }
}
