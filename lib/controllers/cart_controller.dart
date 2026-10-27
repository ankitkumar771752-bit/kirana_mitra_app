import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class CartController extends ChangeNotifier {
  static final CartController instance = CartController._internal();
  CartController._internal();
  factory CartController() => instance;

  final Map<ProductModel, int> _items = {};

  Map<ProductModel, int> get items => _items;

  int get totalItemsCount {
    int count = 0;
    _items.forEach((_, qty) => count += qty);
    return count;
  }

  double get totalPrice {
    double total = 0.0;
    _items.forEach((product, qty) {
      total += product.price * qty;
    });
    return total;
  }

  void addToCart(ProductModel product) {
    if (_items.containsKey(product)) {
      _items[product] = _items[product]! + 1;
    } else {
      _items[product] = 1;
    }
    notifyListeners();
  }

  void removeFromCart(ProductModel product) {
    if (_items.containsKey(product)) {
      if (_items[product]! > 1) {
        _items[product] = _items[product]! - 1;
      } else {
        _items.remove(product);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
