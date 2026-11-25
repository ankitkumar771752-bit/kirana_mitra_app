import 'package:flutter/material.dart';
import '../customers/admin_customers_screen.dart';
import '../stores/admin_stores_screen.dart';
import '../delivery/admin_delivery_screen.dart';
import '../orders/admin_orders_screen.dart';
import '../payments/admin_payments_screen.dart';
import '../reports/admin_reports_screen.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/order_controller.dart';
import '../../../app/routes/app_routes.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    OrderController.instance.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: OrderController.instance,
      builder: (context, child) {
        final totalOrders = OrderController.instance.orders.length;
        double totalRevenue = 0.0;
        for (var o in OrderController.instance.orders) {
          totalRevenue += o.totalAmount;
        }

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text('Admin Dashboard (API Synced)', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: Colors.red),
                onPressed: () {
                  AuthController.instance.logout();
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Welcome, Admin', style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w500)),
                const SizedBox(height: 16),
                // Stat Cards Grid (Live API Data)
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: [
                    const _AdminStatCard(title: 'Total Users', value: '2,540', icon: Icons.group, color: Colors.green),
                    const _AdminStatCard(title: 'Total Stores', value: '320', icon: Icons.store, color: Colors.orange),
                    _AdminStatCard(title: 'Total Orders', value: '$totalOrders', icon: Icons.shopping_bag, color: Colors.blue),
                    _AdminStatCard(title: 'Total Revenue', value: '₹ ${totalRevenue.toStringAsFixed(0)}', icon: Icons.currency_rupee, color: Colors.purple),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('Management', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ActionItem(
                      icon: Icons.people,
                      label: 'Customers',
                      color: Colors.green,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminCustomersScreen())),
                    ),
                    _ActionItem(
                      icon: Icons.store,
                      label: 'Stores',
                      color: Colors.orange,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminStoresScreen())),
                    ),
                    _ActionItem(
                      icon: Icons.delivery_dining,
                      label: 'Delivery',
                      color: Colors.blue,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminDeliveryScreen())),
                    ),
                    _ActionItem(
                      icon: Icons.list_alt,
                      label: 'Orders',
                      color: Colors.purple,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminOrdersScreen())),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('Financials', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ActionItem(
                      icon: Icons.payment,
                      label: 'Payments',
                      color: Colors.teal,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminPaymentsScreen())),
                    ),
                    _ActionItem(
                      icon: Icons.bar_chart,
                      label: 'Reports',
                      color: Colors.indigo,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminReportsScreen())),
                    ),
                  ],
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
              if (index == 1) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminCustomersScreen()));
              } else if (index == 2) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminStoresScreen()));
              } else if (index == 3) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminOrdersScreen()));
              } else if (index == 4) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminReportsScreen()));
              }
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Users'),
              BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Stores'),
              BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Orders'),
              BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Reports'),
            ],
          ),
        );
      },
    );
  }
}

class _AdminStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _AdminStatCard({required this.title, required this.value, required this.icon, required this.color});

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
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
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.black87)),
        ],
      ),
    );
  }
}
