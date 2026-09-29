class ProductModel {
  final String id;
  final String storeId;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String imageUrl;
  final String category;

  ProductModel({
    required this.id,
    required this.storeId,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      storeId: json['storeId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      stock: json['stock'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeId': storeId,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'imageUrl': imageUrl,
      'category': category,
    };
  }
}
