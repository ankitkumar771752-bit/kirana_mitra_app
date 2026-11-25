import 'dart:io';
import 'package:flutter/material.dart';
import '../../../models/product_model.dart';
import '../../../controllers/cart_controller.dart';
import '../../../controllers/wishlist_controller.dart';
import '../../../app/routes/app_routes.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WishlistController.instance.init();
  }

  @override
  Widget build(BuildContext context) {
    final prod = widget.product;
    final originalPrice = prod.price * 1.38; // Mock original price for discount display
    final discountPercent = 28;

    return AnimatedBuilder(
      animation: WishlistController.instance,
      builder: (context, child) {
        final isWishlisted = WishlistController.instance.isInWishlist(prod);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isWishlisted ? Icons.favorite : Icons.favorite_border,
                  color: isWishlisted ? Colors.red : Colors.black87,
                ),
                onPressed: () {
                  WishlistController.instance.toggleWishlist(prod);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(!isWishlisted ? 'Added to Wishlist ❤️' : 'Removed from Wishlist'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87),
                onPressed: () => Navigator.pushNamed(context, AppRoutes.customerCart),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image Header
                Container(
                  height: 300,
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  child: prod.imageUrl.isNotEmpty
                      ? (prod.imageUrl.startsWith('http')
                          ? Image.network(
                              prod.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.shopping_bag, size: 80, color: Colors.green)),
                            )
                          : Image.file(
                              File(prod.imageUrl),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.shopping_bag, size: 80, color: Colors.green)),
                            ))
                      : const Center(child: Icon(Icons.shopping_bag, size: 80, color: Colors.green)),
                ),
                // Title Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: Colors.orange.shade800,
                  width: double.infinity,
                  child: Text(
                    prod.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rating & Expiry Badge Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: const [
                                Text('4.4', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                SizedBox(width: 2),
                                Icon(Icons.star, color: Colors.green, size: 14),
                                SizedBox(width: 4),
                                Text('| 3.5K+', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade700,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('Expiry 24 Jul 2027', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Description / Subtitle
                      Text(
                        prod.description.isNotEmpty ? prod.description : '${prod.name} - Fresh and authentic quality product sourced directly from verified sellers.',
                        style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.4),
                      ),
                      const SizedBox(height: 16),

                      // Discount & Price Row
                      Row(
                        children: [
                          Text('↓$discountPercent%', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20)),
                          const SizedBox(width: 12),
                          Text('₹ ${originalPrice.toStringAsFixed(0)}', style: const TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough, fontSize: 18)),
                          const SizedBox(width: 12),
                          Text('₹ ${prod.price.toStringAsFixed(0)}', style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 24)),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2, offset: const Offset(0, -2))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      CartController.instance.addToCart(prod);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added ${prod.name} to Cart! 🛒'), backgroundColor: Colors.green),
                      );
                    },
                    child: const Text('Go to cart', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC200), // Flipkart Yellow
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      CartController.instance.addToCart(prod);
                      Navigator.pushNamed(context, AppRoutes.customerCheckout);
                    },
                    child: const Text('Buy now', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
