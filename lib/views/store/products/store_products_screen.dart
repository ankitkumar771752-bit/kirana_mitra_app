import 'dart:io';
import 'package:flutter/material.dart';
import '../../../controllers/product_controller.dart';
import 'store_add_product_screen.dart';

class StoreProductsScreen extends StatefulWidget {
  const StoreProductsScreen({super.key});

  @override
  State<StoreProductsScreen> createState() => _StoreProductsScreenState();
}

class _StoreProductsScreenState extends State<StoreProductsScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Groceries', 'Snacks', 'Beverages', 'Household', 'Dairy', 'Personal Care'];

  @override
  void initState() {
    super.initState();
    ProductController.instance.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ProductController.instance,
      builder: (context, child) {
        final allProducts = ProductController.instance.products;
        final filtered = _selectedCategory == 'All'
            ? allProducts
            : allProducts.where((p) => p.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text('Products & Photos', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
          ),
          body: Column(
            children: [
              // Search & Filter Row
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search dynamic products...',
                          prefixIcon: const Icon(Icons.search, color: Colors.green),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Icon(Icons.filter_list, color: Colors.green),
                    ),
                  ],
                ),
              ),
              // Category Chips
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        selectedColor: Colors.green,
                        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold),
                        onSelected: (_) => setState(() => _selectedCategory = cat),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Products: ${allProducts.length}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                    Row(
                      children: const [
                        Text('Newest First', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Icon(Icons.keyboard_arrow_down, size: 16),
                      ],
                    ),
                  ],
                ),
              ),
              // Products List with Photos
              Expanded(
                child: ProductController.instance.isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.green))
                    : filtered.isEmpty
                        ? const Center(child: Text('No products found', style: TextStyle(color: Colors.grey)))
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            itemCount: filtered.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final prod = filtered[index];
                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6, spreadRadius: 2)],
                                ),
                                child: Row(
                                  children: [
                                    // Product Photo instead of icon
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: SizedBox(
                                        height: 55,
                                        width: 55,
                                        child: prod.imageUrl.isNotEmpty
                                            ? (prod.imageUrl.startsWith('http')
                                                ? Image.network(
                                                    prod.imageUrl,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context, error, stackTrace) => Container(
                                                      color: Colors.green.withValues(alpha: 0.1),
                                                      child: const Icon(Icons.shopping_bag, color: Colors.green, size: 28),
                                                    ),
                                                  )
                                                : Image.file(
                                                    File(prod.imageUrl),
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context, error, stackTrace) => Container(
                                                      color: Colors.green.withValues(alpha: 0.1),
                                                      child: const Icon(Icons.shopping_bag, color: Colors.green, size: 28),
                                                    ),
                                                  ))
                                            : Container(
                                                color: Colors.green.withValues(alpha: 0.1),
                                                child: const Icon(Icons.shopping_bag, color: Colors.green, size: 28),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(prod.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                          const SizedBox(height: 2),
                                          Text('₹ ${prod.price.toStringAsFixed(0)}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14)),
                                          const SizedBox(height: 2),
                                          Text('${prod.category} • ${prod.description}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.green.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: const Text('In Stock', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                                        ),
                                        const SizedBox(height: 8),
                                        const Icon(Icons.more_vert, color: Colors.grey),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.green,
            child: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const StoreAddProductScreen()));
            },
          ),
        );
      },
    );
  }
}
