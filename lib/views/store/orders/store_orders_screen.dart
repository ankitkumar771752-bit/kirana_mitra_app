import 'package:flutter/material.dart';
import '../../../controllers/order_controller.dart';
import 'store_order_details_screen.dart';

class StoreOrdersScreen extends StatefulWidget {
  const StoreOrdersScreen({super.key});

  @override
  State<StoreOrdersScreen> createState() => _StoreOrdersScreenState();
}

class _StoreOrdersScreenState extends State<StoreOrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    OrderController.instance.fetchOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: OrderController.instance,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text('Store Orders (Dynamic API)', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.green,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.green,
              isScrollable: true,
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Pending'),
                Tab(text: 'Processing'),
                Tab(text: 'Completed'),
              ],
            ),
          ),
          body: OrderController.instance.isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.green))
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOrdersList(context, 'All'),
                    _buildOrdersList(context, 'Pending'),
                    _buildOrdersList(context, 'Processing'),
                    _buildOrdersList(context, 'Completed'),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildOrdersList(BuildContext context, String filter) {
    final allOrders = OrderController.instance.orders;
    final filtered = filter == 'All'
        ? allOrders
        : allOrders.where((o) => o.status.toLowerCase() == filter.toLowerCase()).toList();

    if (filtered.isEmpty) {
      return const Center(child: Text('No orders found from API', style: TextStyle(color: Colors.grey)));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      separatorBuilder: (_, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final order = filtered[index];
        final orderId = order.id;
        final date = order.createdAt.toString();
        final amount = '₹ ${order.totalAmount.toStringAsFixed(0)}';
        final status = order.status;
        final color = status.toLowerCase() == 'completed'
            ? Colors.green
            : status.toLowerCase() == 'processing'
                ? Colors.blue
                : Colors.orange;

        return Container(
          padding: const EdgeInsets.all(16),
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
                  Text(orderId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
              const SizedBox(height: 6),
              Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoreOrderDetailsScreen(
                            orderId: orderId,
                            status: status,
                            amount: amount,
                            time: date,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward, size: 14, color: Colors.green),
                    label: const Text('View Details', style: TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
