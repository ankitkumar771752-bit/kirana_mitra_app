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
  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    ProductController.instance.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([ProductController.instance, CartController.instance]),
      builder: (context, child) {
        final products = ProductController.instance.products;
        final cartCount = CartController.instance.totalItemsCount;
        
        // Extract unique categories dynamically from API products, with fallback defaults if empty
        final apiCategories = products.map((p) => p.category).where((c) => c.isNotEmpty).toSet();
        final dynamicCategories = ['All', ...apiCategories.isEmpty ? ['Groceries', 'Snacks', 'Beverages', 'Personal Care', 'Home Care'] : apiCategories];

        final filteredProducts = products.where((p) {
          final matchesCat = _selectedCategory == 'All' || p.category.toLowerCase() == _selectedCategory.toLowerCase() || (apiCategories.isEmpty && true);
          final matchesSearch = _searchQuery.isEmpty || p.name.toLowerCase().contains(_searchQuery.toLowerCase()) || p.description.toLowerCase().contains(_searchQuery.toLowerCase());
          return matchesCat && matchesSearch;
        }).toList();

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          body: SafeArea(
            child: RefreshIndicator(
              color: Colors.green,
              onRefresh: () => ProductController.instance.fetchProducts(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  // Deep Green Gradient Top Header
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade900, Colors.green.shade600, Colors.teal.shade700],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.local_grocery_store, color: Colors.yellowAccent, size: 30),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text('KiranaMitra', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                                    Text('Har ghar ki zarurat, ab mobile par.', style: TextStyle(fontSize: 10, color: Colors.white70)),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Stack(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                                      onPressed: () {},
                                    ),
                                    const Positioned(
                                      right: 10,
                                      top: 10,
                                      child: CircleAvatar(radius: 4, backgroundColor: Colors.red),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: const CircleAvatar(backgroundColor: Colors.white, radius: 16, child: Icon(Icons.person, size: 18, color: Colors.green)),
                                  onPressed: () => Navigator.pushNamed(context, AppRoutes.customerProfile),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Search Bar
                        TextField(
                          onChanged: (val) => setState(() => _searchQuery = val),
                          decoration: InputDecoration(
                            hintText: 'Search for products...',
                            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            suffixIcon: const Icon(Icons.mic, color: Colors.green),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Promotional Yellow Banner
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3CD),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Fresh Products\nAt Best Prices', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                              const SizedBox(height: 6),
                              const Text('Groceries | Snacks | Beverages | More', style: TextStyle(fontSize: 11, color: Colors.black54)),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0F5132),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                ),
                                onPressed: () {},
                                child: const Text('Shop Now ➔', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.shopping_basket, size: 80, color: Colors.green),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Categories Icons Row
                  SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: dynamicCategories.length,
                      itemBuilder: (context, index) {
                        final cat = dynamicCategories.elementAt(index);
                        final isSelected = _selectedCategory == cat;
                        final icons = [Icons.all_inclusive, Icons.local_grocery_store, Icons.cookie, Icons.local_drink, Icons.face, Icons.home, Icons.more_horiz];
                        final icon = icons[index % icons.length];

                        return GestureDetector(
                          onTap: () => setState(() => _selectedCategory = cat),
                          child: Container(
                            width: 75,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundColor: isSelected ? Colors.green.shade700 : Colors.green.withValues(alpha: 0.1),
                                  child: Icon(icon, color: isSelected ? Colors.white : Colors.green.shade800, size: 24),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  cat,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? Colors.green.shade800 : Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Top Deals Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Text('🔥', style: TextStyle(fontSize: 18)),
                            SizedBox(width: 4),
                            Text('Top Deals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        TextButton(
                          onPressed: () => setState(() => _selectedCategory = 'All'),
                          child: const Text('View All ➔', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Products Grid from API
                  Builder(
                    builder: (context) {
                      if (filteredProducts.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Center(child: Text('No products found matching criteria', style: TextStyle(color: Colors.grey))),
                        );
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final prod = filteredProducts[index];
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
                                          child: prod.imageUrl.isEmpty
                                              ? Container(
                                                  color: Colors.green.withValues(alpha: 0.1),
                                                  child: const Icon(Icons.shopping_bag, color: Colors.green, size: 35),
                                                )
                                              : prod.imageUrl.startsWith('http')
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
                                                    ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(prod.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Text('₹ ${prod.price.toStringAsFixed(0)}', style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14)),
                                          const SizedBox(width: 6),
                                          Text('₹ ${(prod.price * 1.25).toStringAsFixed(0)}', style: const TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough, fontSize: 11)),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                                        child: const Text('20% OFF', style: TextStyle(color: Colors.green, fontSize: 9, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0F5132),
                                      padding: const EdgeInsets.symmetric(vertical: 6),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    ),
                                    onPressed: () {
                                      CartController.instance.addToCart(prod);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('${prod.name} added to cart!'), backgroundColor: Colors.green),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.shopping_cart, size: 12, color: Colors.white),
                                        const SizedBox(width: 4),
                                        const Text('Add', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
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
              if (index == 1) {} else if (index == 2) {
                Navigator.pushNamed(context, AppRoutes.customerCart);
              } else if (index == 3) {
                Navigator.pushNamed(context, AppRoutes.customerOrders);
              } else if (index == 4) {
                Navigator.pushNamed(context, AppRoutes.customerProfile);
              }
            },
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              const BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Categories'),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    const Icon(Icons.shopping_cart_outlined),
                    if (cartCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                          child: Text('$cartCount', style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                        ),
                      ),
                  ],
                ),
                label: 'Cart',
              ),
              const BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Orders'),
              const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}
