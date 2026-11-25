import 'package:flutter/material.dart';
import '../requests/delivery_requests_screen.dart';
import '../history/delivery_history_screen.dart';
import '../earnings/delivery_earnings_screen.dart';
import '../profile/delivery_profile_screen.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/order_controller.dart';

class DeliveryHomeScreen extends StatefulWidget {
  const DeliveryHomeScreen({super.key});

  @override
  State<DeliveryHomeScreen> createState() => _DeliveryHomeScreenState();
}

class _DeliveryHomeScreenState extends State<DeliveryHomeScreen> {
  int _currentIndex = 0;
  bool isOnline = true;

  @override
  void initState() {
    super.initState();
    OrderController.instance.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([AuthController.instance, OrderController.instance]),
      builder: (context, child) {
        final user = AuthController.instance.currentUser;
        final name = user?.name.isNotEmpty == true ? user!.name : 'Rohit Sharma';
        final orders = OrderController.instance.orders;
        
        final totalDeliveries = orders.length;
        final completed = orders.where((o) => o.status.toLowerCase() == 'completed' || o.status.toLowerCase() == 'delivered').length;
        final pending = orders.where((o) => o.status.toLowerCase() == 'pending' || o.status.toLowerCase() == 'processing').length;
        
        double totalEarnings = 0.0;
        for (var o in completed > 0 ? orders.where((o) => o.status.toLowerCase() == 'completed' || o.status.toLowerCase() == 'delivered') : orders) {
          totalEarnings += o.totalAmount * 0.1; // 10% delivery commission
        }
        if (totalEarnings == 0 && totalDeliveries > 0) totalEarnings = totalDeliveries * 160.0;

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Row(
              children: [
                const Icon(Icons.local_grocery_store, color: Colors.green, size: 28),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('KiranaMitra', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                    Text('Delivery Partner', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.notifications_outlined, color: Colors.black87),
                    if (pending > 0)
                      const Positioned(
                        right: 0,
                        top: 0,
                        child: CircleAvatar(radius: 4, backgroundColor: Colors.red),
                      ),
                  ],
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const CircleAvatar(backgroundColor: Colors.green, radius: 16, child: Icon(Icons.person, size: 18, color: Colors.white)),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DeliveryProfileScreen())),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Partner Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6, spreadRadius: 2)],
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(radius: 28, backgroundColor: Colors.green, child: Icon(Icons.delivery_dining, size: 32, color: Colors.white)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            const Text('Delivery Partner', style: TextStyle(color: Colors.grey, fontSize: 13)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: (isOnline ? Colors.green : Colors.red).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(radius: 4, backgroundColor: isOnline ? Colors.green : Colors.red),
                            const SizedBox(width: 6),
                            Text(isOnline ? 'Online' : 'Offline', style: TextStyle(color: isOnline ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Today's Summary Header & Cards
                const Text("Today's Summary", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _SummaryCard(title: 'Deliveries', value: '$totalDeliveries', icon: Icons.delivery_dining, color: Colors.green)),
                    const SizedBox(width: 8),
                    Expanded(child: _SummaryCard(title: 'Earnings', value: '₹${totalEarnings.toStringAsFixed(0)}', icon: Icons.currency_rupee, color: Colors.green)),
                    const SizedBox(width: 8),
                    Expanded(child: _SummaryCard(title: 'Pending', value: '$pending', icon: Icons.access_time, color: Colors.green)),
                    const SizedBox(width: 8),
                    Expanded(child: _SummaryCard(title: 'Completed', value: '$completed', icon: Icons.check_circle, color: Colors.green)),
                  ],
                ),
                const SizedBox(height: 20),
                // Delivering Happiness Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.green.shade800, Colors.green.shade500]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Delivering Happiness', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            const Text('On Time, Every Time', style: TextStyle(color: Colors.white70, fontSize: 12)),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DeliveryRequestsScreen())),
                              child: const Text('View Orders ➔', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.two_wheeler, size: 65, color: Colors.white70),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Quick Actions (View Orders, Earnings, Profile)
                const Text('Quick Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _QuickActionItem(icon: Icons.receipt_long, label: 'View Orders', color: Colors.green, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DeliveryRequestsScreen()))),
                    _QuickActionItem(icon: Icons.account_balance_wallet, label: 'Earnings', color: Colors.green, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DeliveryEarningsScreen()))),
                    _QuickActionItem(icon: Icons.person_outline, label: 'Profile', color: Colors.green, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DeliveryProfileScreen()))),
                  ],
                ),
                const SizedBox(height: 24),
                // Recent Orders Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Recent Orders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DeliveryHistoryScreen())),
                      child: const Text('View All ➔', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                orders.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Center(child: Text('No recent orders available', style: TextStyle(color: Colors.grey))),
                      )
                    : Column(
                        children: orders.take(2).map((order) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
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
                                  decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                                  child: const Icon(Icons.shopping_bag, color: Colors.green),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(order.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                      const SizedBox(height: 2),
                                      Text(order.createdAt.toString().substring(0, 16), style: const TextStyle(color: Colors.grey, fontSize: 11)),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('₹ ${order.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.green)),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                                      child: Text(order.status, style: const TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex > 3 ? 0 : _currentIndex,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              if (index == 1) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DeliveryRequestsScreen()));
              } else if (index == 2) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DeliveryEarningsScreen()));
              } else if (index == 3) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DeliveryProfileScreen()));
              }
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Orders'),
              BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Earnings'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4, spreadRadius: 1)],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionItem({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: color.withValues(alpha: 0.1),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
