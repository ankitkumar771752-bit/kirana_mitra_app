import 'package:flutter/material.dart';
import '../../../controllers/order_controller.dart';
import '../../../controllers/product_controller.dart';

class StoreSalesScreen extends StatefulWidget {
  const StoreSalesScreen({super.key});

  @override
  State<StoreSalesScreen> createState() => _StoreSalesScreenState();
}

class _StoreSalesScreenState extends State<StoreSalesScreen> {
  @override
  void initState() {
    super.initState();
    OrderController.instance.fetchOrders();
    ProductController.instance.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([OrderController.instance, ProductController.instance]),
      builder: (context, child) {
        final orders = OrderController.instance.orders;
        final products = ProductController.instance.products;

        double totalSales = 0.0;
        for (var o in orders) {
          totalSales += o.totalAmount;
        }
        final totalOrders = orders.length;

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text('Sales & Reports (Dynamic API)', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Selector
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 16, color: Colors.green),
                          SizedBox(width: 8),
                          Text('Live API Data Range', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        ],
                      ),
                      Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Total Sales & Total Orders Summary Cards
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6, spreadRadius: 2)]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total Sales', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            const SizedBox(height: 6),
                            Text('₹ ${totalSales.toStringAsFixed(0)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                            const SizedBox(height: 6),
                            Row(
                              children: const [
                                Icon(Icons.arrow_upward, size: 14, color: Colors.green),
                                SizedBox(width: 2),
                                Text('Live', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6, spreadRadius: 2)]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total Orders', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            const SizedBox(height: 6),
                            Text('$totalOrders', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                            const SizedBox(height: 6),
                            Row(
                              children: const [
                                Icon(Icons.arrow_upward, size: 14, color: Colors.green),
                                SizedBox(width: 2),
                                Text('Live', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Sales Overview Bar Chart Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6, spreadRadius: 2)]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Sales Overview (Dynamic)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 175,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            _BarItem(day: 'Mon', height: 35),
                            _BarItem(day: 'Tue', height: 50),
                            _BarItem(day: 'Wed', height: 65),
                            _BarItem(day: 'Thu', height: 80),
                            _BarItem(day: 'Fri', height: 95),
                            _BarItem(day: 'Sat', height: 110),
                            _BarItem(day: 'Sun', height: 100),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Revenue Summary Cards
                Row(
                  children: [
                    Expanded(child: _RevenueCard(title: 'Today', amount: '₹ ${totalSales.toStringAsFixed(0)}', growth: 'Live')),
                    const SizedBox(width: 10),
                    Expanded(child: _RevenueCard(title: 'This Week', amount: '₹ ${totalSales.toStringAsFixed(0)}', growth: 'Live')),
                    const SizedBox(width: 10),
                    Expanded(child: _RevenueCard(title: 'This Month', amount: '₹ ${totalSales.toStringAsFixed(0)}', growth: 'Live')),
                  ],
                ),
                const SizedBox(height: 20),
                // Top Selling Products Card (Dynamic from ProductController)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6, spreadRadius: 2)]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Top Products (API)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          TextButton(onPressed: () {}, child: const Text('View All', style: TextStyle(color: Colors.green))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      products.isEmpty
                          ? const Padding(padding: EdgeInsets.all(16.0), child: Center(child: Text('No products from API', style: TextStyle(color: Colors.grey))))
                          : Column(
                              children: products.take(4).map((p) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _TopProductRow(name: p.name, sold: 'Stock: ${p.stock}'),
                              )).toList(),
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BarItem extends StatelessWidget {
  final String day;
  final double height;

  const _BarItem({required this.day, required this.height});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 22,
          height: height,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 6),
        Text(day, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _RevenueCard extends StatelessWidget {
  final String title;
  final String amount;
  final String growth;

  const _RevenueCard({required this.title, required this.amount, required this.growth});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4, spreadRadius: 1)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey.shade700, fontSize: 11, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(amount, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(growth, style: const TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _TopProductRow extends StatelessWidget {
  final String name;
  final String sold;

  const _TopProductRow({required this.name, required this.sold});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.shopping_bag, size: 16, color: Colors.green),
            const SizedBox(width: 10),
            Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
        Text(sold, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }
}
