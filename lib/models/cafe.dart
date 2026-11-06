class Cafe {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String address;
  final String category;
  final String? openingHours;
  final String? website;
  final String? phone;

  const Cafe({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.category,
    this.openingHours,
    this.website,
    this.phone,
  });

  factory Cafe.fromOverpassJson(Map<String, dynamic> json) {
    final tags = Map<String, dynamic>.from(
      json['tags'] ?? {},
    );

    final center = json['center'] as Map<String, dynamic>?;

    final latitude = json['lat'] ?? center?['lat'];
    final longitude = json['lon'] ?? center?['lon'];

    final addressParts = [
      tags['addr:street'],
      tags['addr:suburb'],
      tags['addr:city'],
    ].where((value) => value != null && value.toString().isNotEmpty);

    return Cafe(
      id: '${json['type'] ?? 'node'}_${json['id']}',
      name: tags['name']?.toString() ?? 'Cafe tanpa nama',
      latitude: (latitude as num).toDouble(),
      longitude: (longitude as num).toDouble(),
      address: addressParts.isEmpty
          ? 'Alamat tidak tersedia'
          : addressParts.join(', '),
      category: tags['amenity']?.toString() ??
          tags['shop']?.toString() ??
          'cafe',
      openingHours: tags['opening_hours']?.toString(),
      website: tags['website']?.toString(),
      phone: tags['phone']?.toString(),
    );
  }
}