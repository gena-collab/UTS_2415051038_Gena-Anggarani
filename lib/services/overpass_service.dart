
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/cafe.dart';

class OverpassService {
  // Server utama dan server cadangan.
  static const List<String> _baseUrls = [
    'https://maps.mail.ru/osm/tools/overpass/api/interpreter',
    'https://overpass.private.coffee/api/interpreter',
    'https://overpass-api.de/api/interpreter',
  ];

  Future<List<Cafe>> fetchCafes({
    required double latitude,
    required double longitude,
    int radius = 5000,
  }) async {
    final query = '''
[out:json][timeout:25];
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

    final errors = <String>[];

    // Mencoba server satu per satu menggunakan HTTP GET.
    for (final baseUrl in _baseUrls) {
      try {
        final uri = Uri.parse(baseUrl).replace(
          queryParameters: {
            'data': query,
          },
        );

        final response = await http
            .get(
              uri,
              headers: {
                'Accept': 'application/json',
                'User-Agent':
                    'CafeHunt/1.0 (+https://github.com/gena-collab/cafehunt)',
              },
            )
            .timeout(const Duration(seconds: 35));

        if (response.statusCode != 200) {
          errors.add(
            '${Uri.parse(baseUrl).host}: HTTP ${response.statusCode}',
          );
          continue;
        }

        final decoded = jsonDecode(response.body);

        if (decoded is! Map<String, dynamic> ||
            decoded['elements'] is! List) {
          errors.add(
            '${Uri.parse(baseUrl).host}: Format data tidak valid',
          );
          continue;
        }

        final elements = decoded['elements'] as List<dynamic>;

        final cafes = elements.where((element) {
          if (element is! Map<String, dynamic>) {
            return false;
          }

          final tags =
              element['tags'] as Map<String, dynamic>?;

          final center =
              element['center'] as Map<String, dynamic>?;

          final hasLatitude =
              element['lat'] != null ||
              center?['lat'] != null;

          final hasLongitude =
              element['lon'] != null ||
              center?['lon'] != null;

          return tags?['name'] != null &&
              hasLatitude &&
              hasLongitude;
        }).map((element) {
          return Cafe.fromOverpassJson(
            Map<String, dynamic>.from(element as Map),
          );
        }).toList();

        return cafes;
      } catch (e) {
        errors.add('${Uri.parse(baseUrl).host}: $e');
      }
    }

    throw Exception(
      'Semua server API cafe gagal dihubungi. '
      'Periksa koneksi internet dan coba beberapa saat lagi. '
      'Detail: ${errors.join(" | ")}',
    );
  }
}
