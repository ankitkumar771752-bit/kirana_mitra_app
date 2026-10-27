import 'dart:io';
import 'package:flutter/material.dart';
import '../../../controllers/product_controller.dart';

class StoreInventoryScreen extends StatefulWidget {
  const StoreInventoryScreen({super.key});

  @override
  State<StoreInventoryScreen> createState() => _StoreInventoryScreenState();
}

class _StoreInventoryScreenState extends State<StoreInventoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    ProductController.instance.fetchProducts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ProductController.instance,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text('Inventory (Dynamic API)', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.green,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.green,
              tabs: const [
                Tab(text: 'All Products'),
                Tab(text: 'Low Stock'),
                Tab(text: 'Out of Stock'),
              ],
            ),
          ),
          body: ProductController.instance.isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.green))
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildInventoryList('All'),
                    _buildInventoryList('Low Stock'),
                    _buildInventoryList('Out of Stock'),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildInventoryList(String filter) {
    final products = ProductController.instance.products;

    final items = products.map((p) {
      final status = p.stock == 0
          ? 'Out of Stock'
          : p.stock <= 5
              ? 'Low Stock'
              : 'In Stock';
      final color = p.stock == 0
          ? Colors.red
          : p.stock <= 5
              ? Colors.orange
              : Colors.green;

      return {
        'name': p.name,
        'stock': p.stock.toString(),
        'status': status,
        'color': color,
        'imageUrl': p.imageUrl,
      };
    }).toList();

    final filtered = filter == 'All'
        ? items
        : items.where((i) => i['status'] == filter).toList();

    if (filtered.isEmpty) {
      return const Center(child: Text('No inventory items found from API', style: TextStyle(color: Colors.grey)));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = filtered[index];
        final name = item['name'].toString();
        final stock = item['stock'].toString();
        final status = item['status'].toString();
        final color = item['color'] as Color;
        final imageUrl = item['imageUrl'].toString();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6, spreadRadius: 2)],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: imageUrl.isNotEmpty
                      ? (imageUrl.startsWith('http')
                          ? Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.inventory_2, color: Colors.green))
                          : Image.file(File(imageUrl), fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.inventory_2, color: Colors.green)))
                      : Container(
                          color: Colors.green.withValues(alpha: 0.1),
                          child: const Icon(Icons.inventory_2, color: Colors.green),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text('Stock: $stock', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
