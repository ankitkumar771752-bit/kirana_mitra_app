import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class ProductController extends ChangeNotifier {
  final List<ProductModel> _products = [];

  List<ProductModel> get products => _products;

  void setProducts(List<ProductModel> newProducts) {
    _products.clear();
    _products.addAll(newProducts);
    notifyListeners();
  }

  void addProduct(ProductModel product) {
    _products.add(product);
    notifyListeners();
  }
}
