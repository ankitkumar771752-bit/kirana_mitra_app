import 'package:flutter/material.dart';
import '../../../controllers/order_controller.dart';

class DeliveryRequestsScreen extends StatefulWidget {
  const DeliveryRequestsScreen({super.key});

  @override
  State<DeliveryRequestsScreen> createState() => _DeliveryRequestsScreenState();
}

class _DeliveryRequestsScreenState extends State<DeliveryRequestsScreen> {
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
        final orders = OrderController.instance.orders;
        final requests = orders.where((o) => o.status.toLowerCase() == 'pending' || o.status.toLowerCase() == 'processing').toList();

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text('New Delivery Requests', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: OrderController.instance.isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.green))
              : requests.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delivery_dining_outlined, size: 80, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          const Text('No Pending Requests', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                          const SizedBox(height: 8),
                          const Text('New customer delivery requests will appear here', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: requests.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final order = requests[index];
                        final earning = '₹ ${(order.totalAmount * 0.1).toStringAsFixed(0)}';

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
                                  Text(order.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  Text(earning, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text('Drop Address: ${order.deliveryAddress}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87)),
                              const SizedBox(height: 2),
                              Text('Status: ${order.status} • Amount: ₹ ${order.totalAmount.toStringAsFixed(0)}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Colors.red),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      onPressed: () {
                                        OrderController.instance.updateOrderStatus(order.id, 'Cancelled');
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Delivery Rejected'), backgroundColor: Colors.red));
                                      },
                                      child: const Text('Reject', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      onPressed: () {
                                        OrderController.instance.updateOrderStatus(order.id, 'Completed');
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Delivery Accepted & Completed!'), backgroundColor: Colors.green));
                                      },
                                      child: const Text('Accept', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
        );
      },
    );
  }
}
