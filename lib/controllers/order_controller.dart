import 'package:flutter/foundation.dart';
import '../models/order_model.dart';
import '../services/api_service.dart';
import 'auth_controller.dart';

class OrderController extends ChangeNotifier {
  static final OrderController instance = OrderController._internal();
  OrderController._internal();
  factory OrderController() => instance;

  List<OrderModel> _orders = [];
  bool _isLoading = false;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> fetchOrders() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await ApiService.get('/api/orders');
      if (response != null) {
        List<dynamic> list = [];
        if (response is List) {
          list = response;
        } else if (response is Map && response['data'] is List) {
          list = response['data'];
        } else if (response is Map && response['orders'] is List) {
          list = response['orders'];
        }
        _orders = list.map((item) => OrderModel.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching orders from API: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      final userId = AuthController.instance.currentUser?.id;
      await ApiService.put('/api/orders/$orderId', {
        'status': newStatus,
        'deliveryPartnerId': userId,
        'updatedBy': userId,
      });
      await fetchOrders();
    } catch (e) {
      debugPrint('Error updating order status via API: $e');
    }
  }

  Future<bool> createOrder({
    required List<Map<String, dynamic>> items,
    required double totalAmount,
    required String deliveryAddress,
  }) async {
    try {
      final userId = AuthController.instance.currentUser?.id ?? 'cust_1';
      final data = {
        'items': items,
        'totalAmount': totalAmount,
        'deliveryAddress': deliveryAddress,
        'customerId': userId,
        'userId': userId,
        'storeId': 'store_1',
        'status': 'pending',
      };
      await ApiService.post('/api/orders', data);
      await fetchOrders();
      return true;
    } catch (e) {
      debugPrint('Error creating order via API: $e');
      throw Exception('Failed to create order on server: $e');
    }
  }
}
