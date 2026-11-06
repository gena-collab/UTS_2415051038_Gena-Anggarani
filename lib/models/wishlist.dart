class Wishlist {
  final String? id;
  final String cafeId;
  final String cafeName;
  final String address;
  final double latitude;
  final double longitude;
  final DateTime createdAt;

  const Wishlist({
    this.id,
    required this.cafeId,
    required this.cafeName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
  });

  factory Wishlist.fromJson(Map<String, dynamic> json) {
    return Wishlist(
      id: json['id']?.toString(),
      cafeId: json['cafe_id'].toString(),
      cafeName: json['cafe_name'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cafe_id': cafeId,
      'cafe_name': cafeName,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt.toIso8601String(),
    };
  }
}