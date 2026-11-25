import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class WishlistController extends ChangeNotifier {
  static final WishlistController instance = WishlistController._internal();
  WishlistController._internal();
  factory WishlistController() => instance;

  final List<ProductModel> _wishlistItems = [];

  static const String _globalKey = 'kiranamitra_global_customer_wishlist';

  Future<void> _persistLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(_wishlistItems.map((p) => p.toJson()).toList());
      await prefs.setString(_globalKey, jsonString);
    } catch (e) {
      debugPrint('Error persisting wishlist locally: $e');
    }
  }

  Future<void> _loadLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_globalKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        _wishlistItems.clear();
        for (var item in decoded) {
          if (item is Map<String, dynamic>) {
            _wishlistItems.add(ProductModel.fromJson(item));
          }
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading local wishlist: $e');
    }
  }

  Future<void> init() async {
    await fetchWishlist();
  }

  List<ProductModel> get wishlistItems => _wishlistItems;

  Future<void> fetchWishlist() async {
    await _loadLocal();
    try {
      final response = await ApiService.get('/api/wishlist');
      if (response != null) {
        List<dynamic> list = [];
        if (response is List) {
          list = response;
        } else if (response is Map) {
          for (var key in ['data', 'wishlist', 'result', 'items', 'content', 'payload', 'list']) {
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
        
        final serverWishlist = list.map((item) => ProductModel.fromJson(item is Map ? Map<String, dynamic>.from(item) : {})).toList();
        
        // Merge server wishlist with local wishlist so items never disappear
        final Map<String, ProductModel> combined = {};
        for (var p in _wishlistItems) {
          final id = p.id.isNotEmpty ? p.id : p.name;
          combined[id] = p;
        }
        for (var p in serverWishlist) {
          final id = p.id.isNotEmpty ? p.id : p.name;
          if (p.name.isNotEmpty) {
            combined[id] = p;
          }
        }
        _wishlistItems.clear();
        _wishlistItems.addAll(combined.values);
        await _persistLocal();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching wishlist from API: $e');
    }
  }

  bool isInWishlist(ProductModel product) {
    final id = product.id.isNotEmpty ? product.id : product.name;
    return _wishlistItems.any((p) => (p.id.isNotEmpty ? p.id : p.name) == id);
  }

  Future<void> toggleWishlist(ProductModel product) async {
    await _loadLocal();
    final id = product.id.isNotEmpty ? product.id : product.name;
    final index = _wishlistItems.indexWhere((p) => (p.id.isNotEmpty ? p.id : p.name) == id);
    if (index >= 0) {
      _wishlistItems.removeAt(index);
    } else {
      _wishlistItems.add(product);
    }
    await _persistLocal();
    notifyListeners();

    try {
      await ApiService.post('/api/wishlist', {
        'productId': product.id,
        'name': product.name,
        'price': product.price,
        'category': product.category,
        'image': product.imageUrl,
      });
    } catch (e) {
      debugPrint('Error toggling wishlist via API: $e');
    }
  }

  Future<void> removeFromWishlist(ProductModel product) async {
    final id = product.id.isNotEmpty ? product.id : product.name;
    _wishlistItems.removeWhere((p) => (p.id.isNotEmpty ? p.id : p.name) == id);
    await _persistLocal();
    notifyListeners();

    try {
      await ApiService.delete('/api/wishlist/${product.id}');
    } catch (e) {
      debugPrint('Error removing from wishlist via API: $e');
    }
  }
}
