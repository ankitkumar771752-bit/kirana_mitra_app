import 'package:flutter/material.dart';

class AdminStoresScreen extends StatelessWidget {
  const AdminStoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stores = [
      {'name': 'Sharma General Store', 'owner': 'Raman Sharma', 'location': 'Green Park, Gwalior', 'sales': '₹ 45,000', 'status': 'Approved'},
      {'name': 'Gupta Kirana & Daily Needs', 'owner': 'Suresh Gupta', 'location': 'City Center, Gwalior', 'sales': '₹ 62,000', 'status': 'Approved'},
      {'name': 'Mahalaxmi Groceries', 'owner': 'Vijay Patel', 'location': 'Lashkar, Gwalior', 'sales': '₹ 18,500', 'status': 'Pending'},
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Manage Stores', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: stores.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final store = stores[index];
          final isApproved = store['status'] == 'Approved';

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6, spreadRadius: 2)],
            ),
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.store, color: Colors.orange),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(store['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 2),
                      Text('Owner: ${store['owner']} • ${store['location']}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text('Monthly Sales: ${store['sales']}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (isApproved ? Colors.green : Colors.orange).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    store['status']!,
                    style: TextStyle(color: isApproved ? Colors.green : Colors.orange, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
