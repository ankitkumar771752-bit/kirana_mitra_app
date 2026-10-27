import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_model.dart';
import '../services/api_service.dart';

class OrderController extends ChangeNotifier {
  static final OrderController instance = OrderController._internal();
  OrderController._internal();
  factory OrderController() => instance;

  List<OrderModel> _orders = [];
  bool _isLoading = false;
  bool _isInitialized = false;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;

  static const String _keySavedOrders = 'saved_store_orders';

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_keySavedOrders);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        _orders = decoded.map((item) => OrderModel.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint('Error loading locally persisted orders: $e');
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> _persistOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(_orders.map((o) => o.toJson()).toList());
      await prefs.setString(_keySavedOrders, jsonString);
    } catch (e) {
      debugPrint('Error persisting orders locally: $e');
    }
  }

  Future<void> fetchOrders() async {
    await init();
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
        if (list.isNotEmpty) {
          _orders = list.map((item) => OrderModel.fromJson(item)).toList();
          await _persistOrders();
        }
      }
    } catch (e) {
      debugPrint('Error fetching orders from API (using local persisted orders): $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await init();
    try {
      await ApiService.put('/api/orders/$orderId', {'status': newStatus});
    } catch (e) {
      debugPrint('Error updating order status via API: $e');
    }
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final old = _orders[index];
      _orders[index] = OrderModel(
        id: old.id,
        customerId: old.customerId,
        storeId: old.storeId,
        deliveryPartnerId: old.deliveryPartnerId,
        items: old.items,
        totalAmount: old.totalAmount,
        status: newStatus,
        deliveryAddress: old.deliveryAddress,
        createdAt: old.createdAt,
      );
      await _persistOrders();
      notifyListeners();
    }
  }
}
