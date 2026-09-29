import 'package:flutter/foundation.dart';
import '../models/order_model.dart';

class OrderController extends ChangeNotifier {
  final List<OrderModel> _orders = [];

  List<OrderModel> get orders => _orders;

  void setOrders(List<OrderModel> newOrders) {
    _orders.clear();
    _orders.addAll(newOrders);
    notifyListeners();
  }

  void addOrder(OrderModel order) {
    _orders.add(order);
    notifyListeners();
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      // Create updated order or modify if mutable
      notifyListeners();
    }
  }
}
