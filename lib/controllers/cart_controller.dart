import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class CartController extends ChangeNotifier {
  static final CartController instance = CartController._internal();
  CartController._internal();
  factory CartController() => instance;

  final Map<String, MapEntry<ProductModel, int>> _items = {};

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

  void addToCart(ProductModel product) {
    final key = product.id.isNotEmpty ? product.id : product.name;
    debugPrint('CartController: Adding product "${product.name}" (ID: ${product.id}, Key: $key)');
    if (_items.containsKey(key)) {
      final currentQty = _items[key]!.value;
      _items[key] = MapEntry(product, currentQty + 1);
    } else {
      _items[key] = MapEntry(product, 1);
    }
    debugPrint('CartController: Total unique items in cart: ${_items.length}');
    notifyListeners();
  }

  void removeFromCart(ProductModel product) {
    final key = product.id.isNotEmpty ? product.id : product.name;
    if (_items.containsKey(key)) {
      final currentQty = _items[key]!.value;
      if (currentQty > 1) {
        _items[key] = MapEntry(product, currentQty - 1);
      } else {
        _items.remove(key);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
