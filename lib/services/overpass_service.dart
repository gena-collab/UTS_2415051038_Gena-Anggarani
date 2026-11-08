
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cafe.dart';

class OverpassService {
  static const List<String> _servers = [
    'https://maps.mail.ru/osm/tools/overpass/api/interpreter',
    'https://overpass.private.coffee/api/interpreter',
    'https://overpass-api.de/api/interpreter',
  ];

  Future<List<Cafe>> fetchCafes({
    required double latitude,
    required double longitude,
    int radius = 1000,
  }) async {
    final query = '''
[out:json][timeout:20];
node(around:$radius,$latitude,$longitude)["amenity"="cafe"];
out 10;
''';

    final errors = <String>[];

    for (final server in _servers) {
      try {
        print('CAFE API: Mencoba $server');

        final uri = Uri.parse(server).replace(
          queryParameters: {'data': query},
        );

        final response = await http.get(
          uri,
          headers: {
            'Accept': 'application/json',
            'User-Agent': 'CafeHunt/1.0',
          },
        ).timeout(const Duration(seconds: 25));

        if (response.statusCode != 200) {
          errors.add('$server: HTTP ${response.statusCode}');
          print('CAFE API: HTTP ${response.statusCode}');
          continue;
        }

        final decoded = jsonDecode(response.body);

        if (decoded is! Map || decoded['elements'] is! List) {
          errors.add('$server: Format JSON tidak valid');
          continue;
        }

        final cafes = <Cafe>[];

        for (final element in decoded['elements']) {
          if (element is! Map) continue;

          final data = Map<String, dynamic>.from(element);
          final tags = data['tags'];

          if (tags is! Map || tags['name'] == null) continue;
          if (data['lat'] == null || data['lon'] == null) continue;

          cafes.add(Cafe.fromOverpassJson(data));
        }

        print('CAFE API BERHASIL: ${cafes.length} data ditemukan');
        return cafes;
      } catch (e) {
        errors.add('$server: $e');
        print('CAFE API GAGAL: $server | $e');
      }

      await Future.delayed(const Duration(seconds: 2));
    }

    throw Exception(
      'Semua server Overpass gagal. ${errors.join(' | ')}',
    );
  }
}
