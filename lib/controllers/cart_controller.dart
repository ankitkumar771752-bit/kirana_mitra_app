import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class CartController extends ChangeNotifier {
  static final CartController instance = CartController._internal();
  CartController._internal();
  factory CartController() => instance;

  final Map<String, MapEntry<ProductModel, int>> _items = {};

  static const String _globalKey = 'kiranamitra_global_customer_cart';

  Future<void> _persistLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _items.values.map((entry) => {
        'product': entry.key.toJson(),
        'quantity': entry.value,
      }).toList();
      await prefs.setString(_globalKey, jsonEncode(list));
    } catch (e) {
      debugPrint('Error persisting cart locally: $e');
    }
  }

  Future<void> _loadLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_globalKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        _items.clear();
        for (var item in decoded) {
          if (item is Map<String, dynamic>) {
            final product = ProductModel.fromJson(item['product']);
            final qty = item['quantity'] as int? ?? 1;
            final key = product.id.isNotEmpty ? product.id : product.name;
            _items[key] = MapEntry(product, qty);
          }
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading local cart: $e');
    }
  }

  Future<void> init() async {
    await fetchCart();
  }

  Map<ProductModel, int> get items {
    final Map<ProductModel, int> map = {};
    _items.forEach((_, entry) {
      map[entry.key] = entry.value;
    });
    return map;
  }

  int get totalItemsCount {
    int count = 0;
    _items.forEach((_, entry) => count += entry.value);
    return count;
  }

  double get totalPrice {
    double total = 0.0;
    _items.forEach((_, entry) {
      total += entry.key.price * entry.value;
    });
    return total;
  }

  Future<void> fetchCart() async {
    await _loadLocal();
    try {
      final response = await ApiService.get('/api/cart');
      if (response != null) {
        List<dynamic> list = [];
        if (response is List) {
          list = response;
        } else if (response is Map) {
          for (var key in ['data', 'cart', 'items', 'result', 'content', 'payload', 'list']) {
            if (response[key] is List) {
              list = response[key];
              break;
            }
          }
          if (list.isEmpty) {
            for (var val in response.values) {
              if (val is List) {
                list = val;
                break;
              }
            }
          }
        }
        
        final Map<String, MapEntry<ProductModel, int>> serverItems = {};
        for (var item in list) {
          if (item is Map) {
            final prodMap = item['product'] ?? item;
            final product = ProductModel.fromJson(Map<String, dynamic>.from(prodMap));
            final qty = item['quantity'] as int? ?? 1;
            final key = product.id.isNotEmpty ? product.id : product.name;
            serverItems[key] = MapEntry(product, qty);
          }
        }

        // Merge server items with local items so items never disappear on refresh
        for (var entry in _items.entries) {
          if (!serverItems.containsKey(entry.key)) {
            serverItems[entry.key] = entry.value;
          }
        }
        _items.clear();
        _items.addAll(serverItems);
        await _persistLocal();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching cart from API: $e');
    }
  }

  Future<void> addToCart(ProductModel product) async {
    await _loadLocal();
    final key = product.id.isNotEmpty ? product.id : product.name;
    if (_items.containsKey(key)) {
      final currentQty = _items[key]!.value;
      _items[key] = MapEntry(product, currentQty + 1);
    } else {
      _items[key] = MapEntry(product, 1);
    }
    await _persistLocal();
    notifyListeners();

    try {
      await ApiService.post('/api/cart', {
        'productId': product.id,
        'name': product.name,
        'price': product.price,
        'quantity': _items[key]!.value,
      });
    } catch (e) {
      debugPrint('Error posting cart item to API: $e');
    }
  }

  Future<void> removeFromCart(ProductModel product) async {
    await _loadLocal();
    final key = product.id.isNotEmpty ? product.id : product.name;
    if (_items.containsKey(key)) {
      final currentQty = _items[key]!.value;
      if (currentQty > 1) {
        _items[key] = MapEntry(product, currentQty - 1);
      } else {
        _items.remove(key);
      }
      await _persistLocal();
      notifyListeners();

      try {
        await ApiService.delete('/api/cart/${product.id}');
      } catch (e) {
        debugPrint('Error removing cart item via API: $e');
      }
    }
  }

  Future<void> clearCart() async {
    _items.clear();
    await _persistLocal();
    notifyListeners();

    try {
      await ApiService.delete('/api/cart');
    } catch (e) {
      debugPrint('Error clearing cart via API: $e');
    }
  }
}
