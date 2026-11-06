import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/cafe.dart';

class OverpassService {
  static const String _baseUrl =
    'https://maps.mail.ru/osm/tools/overpass/api/interpreter';
  Future<List<Cafe>> fetchCafes({
    required double latitude,
    required double longitude,
    int radius = 5000,
  }) async {
    const timeout = Duration(seconds: 60);

    final query = '''
[out:json][timeout:30];
(
  node["amenity"~"cafe|coffee_shop|coworking_space"](around:$radius,$latitude,$longitude);
  way["amenity"~"cafe|coffee_shop|coworking_space"](around:$radius,$latitude,$longitude);
  relation["amenity"~"cafe|coffee_shop|coworking_space"](around:$radius,$latitude,$longitude);

  node["shop"="bakery"](around:$radius,$latitude,$longitude);
  way["shop"="bakery"](around:$radius,$latitude,$longitude);
  relation["shop"="bakery"](around:$radius,$latitude,$longitude);
);
out center tags;
''';

    final response = await http
        .post(
          Uri.parse(_baseUrl),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json',
            'User-Agent':
               'CafeHunt/1.0 (+https://github.com/gena-collab/cafehunt)',
          },
          body: {'data': query},
        )
        .timeout(timeout);

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil data cafe: ${response.statusCode}',
      );
    }

    final decoded = jsonDecode(response.body);
    final elements = decoded['elements'] as List<dynamic>;

    return elements
        .where((element) {
          final tags = element['tags'] as Map<String, dynamic>?;
          final hasLatitude =
              element['lat'] != null || element['center']?['lat'] != null;
          final hasLongitude =
              element['lon'] != null || element['center']?['lon'] != null;

          return tags?['name'] != null &&
              hasLatitude &&
              hasLongitude;
        })
        .map(
          (element) => Cafe.fromOverpassJson(
            Map<String, dynamic>.from(element),
          ),
        )
        .toList();
  }
}