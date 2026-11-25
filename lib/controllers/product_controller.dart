import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductController extends ChangeNotifier {
  static final ProductController instance = ProductController._internal();
  ProductController._internal() {
    _startPolling();
  }
  factory ProductController() => instance;

  List<ProductModel> _products = [];
  bool _isLoading = false;
  Timer? _pollingTimer;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      fetchProducts(silent: true);
    });
  }

  static const String _globalKey = 'kiranamitra_global_catalog_products';

  Future<void> _persistLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(_products.map((p) => p.toJson()).toList());
      await prefs.setString(_globalKey, jsonString);
    } catch (e) {
      debugPrint('Error persisting global products locally: $e');
    }
  }

  Future<void> _loadLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_globalKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        _products = decoded.map((item) => ProductModel.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading global local products: $e');
    }
  }

  Future<void> fetchProducts({bool silent = false}) async {
    if (!silent) {
      await _loadLocal();
      _isLoading = true;
      notifyListeners();
    }
    try {
      final response = await ApiService.get('/api/products');
      if (response != null) {
        List<dynamic> list = [];
        if (response is List) {
          list = response;
        } else if (response is Map) {
          for (var key in ['data', 'products', 'result', 'items', 'content', 'payload', 'list']) {
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
        
        final serverProducts = list.map((item) => ProductModel.fromJson(item is Map ? Map<String, dynamic>.from(item) : {})).toList();
        
        // Merge server products with local products
        final Map<String, ProductModel> combined = {};
        for (var p in _products) {
          final key = p.name.toLowerCase().trim();
          combined[key] = p;
        }
        for (var p in serverProducts) {
          if (p.name.isNotEmpty) {
            final key = p.name.toLowerCase().trim();
            combined[key] = p;
          }
        }
        _products = combined.values.toList();
        await _persistLocal();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching products from API: $e');
    } finally {
      if (!silent) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<bool> addProduct({
    required String name,
    required String category,
    required double price,
    required int stock,
    required String description,
    String? imageUrl,
  }) async {
    final tempId = 'prod_${DateTime.now().millisecondsSinceEpoch}';

    // 1. Optimistic UI update & global persistence
    final newProduct = ProductModel(
      id: tempId,
      storeId: 'store_1',
      name: name,
      description: description,
      price: price,
      stock: stock,
      imageUrl: imageUrl ?? '',
      category: category,
    );
    
    _products.removeWhere((p) => p.name.toLowerCase().trim() == name.toLowerCase().trim());
    _products.insert(0, newProduct);
    await _persistLocal();
    notifyListeners();

    // 2. Send to backend API
    try {
      final data = {
        'name': name,
        'title': name,
        'category': category,
        'price': price,
        'amount': price,
        'stock': stock,
        'quantity': stock,
        'image': imageUrl ?? '',
        'imageUrl': imageUrl ?? '',
        'description': description,
        'store_id': null,
        'storeId': null,
      };
      
      await ApiService.post('/api/products', data);
      await fetchProducts();
    } catch (e) {
      debugPrint('Error posting product to API: $e');
    }
    return true;
  }
}
