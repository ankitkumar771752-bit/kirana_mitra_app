class OrderModel {
  final String id;
  final String customerId;
  final String storeId;
  final String? deliveryPartnerId;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final String status; // 'pending', 'accepted', 'out_for_delivery', 'delivered', 'cancelled'
  final String deliveryAddress;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.customerId,
    required this.storeId,
    this.deliveryPartnerId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.deliveryAddress,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      customerId: json['customerId'] ?? '',
      storeId: json['storeId'] ?? '',
      deliveryPartnerId: json['deliveryPartnerId'],
      items: List<Map<String, dynamic>>.from(json['items'] ?? []),
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'pending',
      deliveryAddress: json['deliveryAddress'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'storeId': storeId,
      'deliveryPartnerId': deliveryPartnerId,
      'items': items,
      'totalAmount': totalAmount,
      'status': status,
      'deliveryAddress': deliveryAddress,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
