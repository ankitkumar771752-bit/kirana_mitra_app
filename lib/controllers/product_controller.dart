import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductController extends ChangeNotifier {
  static final ProductController instance = ProductController._internal();
  ProductController._internal();
  factory ProductController() => instance;

  List<ProductModel> _products = [];
  bool _isLoading = false;
  bool _isInitialized = false;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;

  static const String _keySavedProducts = 'saved_store_products';

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_keySavedProducts);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        _products = decoded.map((item) => ProductModel.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint('Error loading locally persisted products: $e');
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> _persistProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(_products.map((p) => p.toJson()).toList());
      await prefs.setString(_keySavedProducts, jsonString);
    } catch (e) {
      debugPrint('Error persisting products locally: $e');
    }
  }

  Future<void> fetchProducts() async {
    await init();
    _isLoading = true;
    notifyListeners();
    try {
      final response = await ApiService.get('/api/products');
      if (response != null) {
        List<dynamic> list = [];
        if (response is List) {
          list = response;
        } else if (response is Map && response['data'] is List) {
          list = response['data'];
        } else if (response is Map && response['products'] is List) {
          list = response['products'];
        }
        if (list.isNotEmpty) {
          _products = list.map((item) => ProductModel.fromJson(item)).toList();
          await _persistProducts();
        }
      }
    } catch (e) {
      debugPrint('Error fetching products from API (using local persisted data): $e');
    } finally {
      _isLoading = false;
      notifyListeners();
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
    await init();
    try {
      final data = {
        'store_id': null,
        'category_id': null,
        'name': name,
        'price': price,
        'stock': stock,
        'image': imageUrl ?? '',
        'description': description,
      };
      final response = await ApiService.post('/api/products', data);
      String generatedId = 'prod_${DateTime.now().millisecondsSinceEpoch}';
      if (response != null && response is Map) {
        if (response['id'] != null) {
          generatedId = response['id'].toString();
        } else if (response['_id'] != null) {
          generatedId = response['_id'].toString();
        }
      }

      final newProd = ProductModel(
        id: generatedId,
        storeId: 'store_1',
        name: name,
        price: price,
        stock: stock,
        imageUrl: imageUrl ?? '',
        description: description,
        category: category,
      );
      _products.add(newProd);
      await _persistProducts();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error posting product to API (saving locally): $e');
    }

    _products.add(ProductModel(
      id: 'prod_${DateTime.now().millisecondsSinceEpoch}',
      storeId: 'store_1',
      name: name,
      price: price,
      stock: stock,
      imageUrl: imageUrl ?? '',
      description: description,
      category: category,
    ));
    await _persistProducts();
    notifyListeners();
    return true;
  }
}
