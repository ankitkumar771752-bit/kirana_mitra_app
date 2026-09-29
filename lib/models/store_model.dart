class StoreModel {
  final String id;
  final String ownerId;
  final String name;
  final String address;
  final String phone;
  final bool isOpen;
  final String logoUrl;

  StoreModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.address,
    required this.phone,
    required this.isOpen,
    required this.logoUrl,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'] ?? '',
      ownerId: json['ownerId'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      isOpen: json['isOpen'] ?? true,
      logoUrl: json['logoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'address': address,
      'phone': phone,
      'isOpen': isOpen,
      'logoUrl': logoUrl,
    };
  }
}
