import 'package:flutter/material.dart';
import '../../../controllers/product_controller.dart';
import '../../../controllers/order_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../products/store_products_screen.dart';
import '../products/store_add_product_screen.dart';
import '../inventory/store_inventory_screen.dart';
import '../orders/store_orders_screen.dart';
import '../sales/store_sales_screen.dart';
import '../profile/store_profile_screen.dart';

class StoreDashboardScreen extends StatefulWidget {
  const StoreDashboardScreen({super.key});

  @override
  State<StoreDashboardScreen> createState() => _StoreDashboardScreenState();
}

class _StoreDashboardScreenState extends State<StoreDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _DashboardHomeTab(),
    const StoreProductsScreen(),
    const StoreOrdersScreen(),
    const StoreSalesScreen(),
    const StoreProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex > 4 ? 0 : _currentIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Products'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Sales'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class _DashboardHomeTab extends StatefulWidget {
  const _DashboardHomeTab();

  @override
  State<_DashboardHomeTab> createState() => _DashboardHomeTabState();
}

class _DashboardHomeTabState extends State<_DashboardHomeTab> {
  @override
  void initState() {
    super.initState();
    ProductController.instance.fetchProducts();
    OrderController.instance.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([ProductController.instance, OrderController.instance, AuthController.instance]),
      builder: (context, child) {
        final totalProducts = ProductController.instance.products.length;
        final totalOrders = OrderController.instance.orders.length;
        final pendingOrders = OrderController.instance.orders.where((o) => o.status.toLowerCase() == 'pending').length;

        double todaysSales = 0.0;
        for (var o in OrderController.instance.orders) {
          todaysSales += o.totalAmount;
        }
        
        final user = AuthController.instance.currentUser;
        final storeName = user?.name.isNotEmpty == true ? user!.name : 'Kirana Mitra Store';

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(color: Colors.green.shade100, shape: BoxShape.circle),
                  child: const Icon(Icons.store, color: Colors.green, size: 24),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(storeName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                    Text('Products: $totalProducts • API Synced', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            actions: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: const Text('Online', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
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
                // Stats Cards Row
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(title: 'Total Orders', value: '$totalOrders', icon: Icons.shopping_bag_rounded, color: Colors.blue, growth: 'Live'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatCard(title: "Today's Sales", value: '₹ ${todaysSales.toStringAsFixed(0)}', icon: Icons.currency_rupee, color: Colors.green, growth: 'Live'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatCard(title: 'Pending Orders', value: '$pendingOrders', icon: Icons.hourglass_top, color: Colors.orange, growth: 'Live'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Grow Your Store Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.green.shade700, Colors.green.shade500]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Grow Your Store', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            const Text('More Customers, More Orders', style: TextStyle(color: Colors.white70, fontSize: 12)),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const StoreSalesScreen()));
                              },
                              child: const Text('View Insights', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.local_shipping, size: 65, color: Colors.white54),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Quick Actions
                const Text('Quick Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ActionItem(
                      icon: Icons.add_circle_outline,
                      label: 'Add Product',
                      color: Colors.green,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StoreAddProductScreen())),
                    ),
                    _ActionItem(
                      icon: Icons.inventory_2_outlined,
                      label: 'Inventory',
                      color: Colors.blue,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StoreInventoryScreen())),
                    ),
                    _ActionItem(
                      icon: Icons.list_alt_rounded,
                      label: 'View Orders',
                      color: Colors.orange,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StoreOrdersScreen())),
                    ),
                    _ActionItem(
                      icon: Icons.bar_chart_rounded,
                      label: 'Sales & Reports',
                      color: Colors.purple,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StoreSalesScreen())),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Recent Dynamic Orders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StoreOrdersScreen())),
                      child: const Text('View All', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Recent Orders List from API
                OrderController.instance.orders.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Center(child: Text('No orders from API yet', style: TextStyle(color: Colors.grey))),
                      )
                    : Column(
                        children: OrderController.instance.orders.take(3).map((order) {
                          final color = order.status.toLowerCase() == 'completed'
                              ? Colors.green
                              : order.status.toLowerCase() == 'processing'
                                  ? Colors.blue
                                  : Colors.orange;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _OrderTile(
                              orderId: order.id,
                              status: order.status,
                              amount: '₹ ${order.totalAmount.toStringAsFixed(0)}',
                              time: order.createdAt.toString().substring(0, 16),
                              color: color,
                            ),
                          );
                        }).toList(),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String growth;

  const _StatCard({required this.title, required this.value, required this.icon, required this.color, required this.growth});

  @override
  Widget build(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 18),
              Text(growth, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionItem({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  final String orderId;
  final String status;
  final String amount;
  final String time;
  final Color color;

  const _OrderTile({required this.orderId, required this.status, required this.amount, required this.time, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 4, spreadRadius: 1)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.receipt, color: Colors.green, size: 18),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(orderId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
