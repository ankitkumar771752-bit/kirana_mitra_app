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
      id: json['id']?.toString() ?? json['product_id']?.toString() ?? json['_id']?.toString() ?? json['productId']?.toString() ?? '',
      storeId: json['storeId']?.toString() ?? json['store_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      stock: (json['stock'] ?? json['quantity'] ?? 0).toInt(),
      imageUrl: json['imageUrl']?.toString() ?? json['image']?.toString() ?? '',
      category: json['category']?.toString() ?? json['category_id']?.toString() ?? '',
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModel && runtimeType == other.runtimeType && (id == other.id || (id.isNotEmpty && id == other.id));

  @override
  int get hashCode => id.isNotEmpty ? id.hashCode : name.hashCode;
}
