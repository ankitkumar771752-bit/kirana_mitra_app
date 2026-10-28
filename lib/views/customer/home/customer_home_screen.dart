import 'dart:io';
import 'package:flutter/material.dart';
import '../../../app/routes/app_routes.dart';
import '../../../controllers/product_controller.dart';
import '../../../controllers/cart_controller.dart';
import '../products/product_details_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _currentIndex = 0;

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
        final products = ProductController.instance.products;

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.green),
                const SizedBox(width: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Bettiah, Bihar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                    Text('Deliver to home (API Synced)', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.black87),
                onPressed: () {},
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for dynamic products...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Promotional Banner
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Colors.green, Colors.teal],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Fresh & Healthy\nGroceries',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Up to 20% OFF',
                                style: TextStyle(fontSize: 14, color: Colors.orangeAccent, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.local_grocery_store, size: 70, color: Colors.white70),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Categories
                const Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    _CategoryItem(icon: Icons.eco, label: 'Fruits'),
                    _CategoryItem(icon: Icons.grass, label: 'Vegetables'),
                    _CategoryItem(icon: Icons.local_drink, label: 'Dairy'),
                    _CategoryItem(icon: Icons.cookie, label: 'Snacks'),
                    _CategoryItem(icon: Icons.coffee, label: 'Beverages'),
                  ],
                ),
                const SizedBox(height: 24),
                // Top Deals Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Top Deals & Dynamic Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {},
                      child: const Text('View All', style: TextStyle(color: Colors.green)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Products Grid from API
                products.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Center(child: Text('No products available from API', style: TextStyle(color: Colors.grey))),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final prod = products[index];
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6, spreadRadius: 2)],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Tappable Area for Product Details
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductDetailsScreen(product: prod),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: SizedBox(
                                          height: 90,
                                          width: double.infinity,
                                          child: prod.imageUrl.isNotEmpty
                                              ? (prod.imageUrl.startsWith('http')
                                                  ? Image.network(
                                                      prod.imageUrl,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context, error, stackTrace) => Container(
                                                        color: Colors.green.withValues(alpha: 0.1),
                                                        child: const Icon(Icons.shopping_bag, color: Colors.green, size: 35),
                                                      ),
                                                    )
                                                  : Image.file(
                                                      File(prod.imageUrl),
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context, error, stackTrace) => Container(
                                                        color: Colors.green.withValues(alpha: 0.1),
                                                        child: const Icon(Icons.shopping_bag, color: Colors.green, size: 35),
                                                      ),
                                                    ))
                                              : Container(
                                                  color: Colors.green.withValues(alpha: 0.1),
                                                  child: const Icon(Icons.shopping_bag, color: Colors.green, size: 35),
                                                ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(prod.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                      const SizedBox(height: 2),
                                      Text('₹ ${prod.price.toStringAsFixed(0)}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13)),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: const EdgeInsets.symmetric(vertical: 6),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    onPressed: () {
                                      CartController.instance.addToCart(prod);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('${prod.name} added to cart!'), backgroundColor: Colors.green),
                                      );
                                    },
                                    child: const Text('Add to Cart', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              if (index == 2) {
                Navigator.pushNamed(context, AppRoutes.customerCart);
              } else if (index == 3) {
                Navigator.pushNamed(context, AppRoutes.customerOrders);
              } else if (index == 4) {
                Navigator.pushNamed(context, AppRoutes.customerProfile);
              }
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Categories'),
              BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
              BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Orders'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CategoryItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          child: Icon(icon, color: Colors.green),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
