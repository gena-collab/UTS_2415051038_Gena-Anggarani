import 'package:flutter_test/flutter_test.dart';
import 'package:cafehunt/models/cafe.dart';

void main() {
  group('Cafe.fromOverpassJson', () {
    test('berhasil membaca data cafe dari JSON node', () {
      final json = {
        'type': 'node',
        'id': 12345,
        'lat': -8.112,
        'lon': 115.088,
        'tags': {
          'name': 'Cafe Ganesha',
          'amenity': 'cafe',
          'addr:street': 'Jalan Sudirman',
          'addr:city': 'Singaraja',
          'opening_hours': '08:00-22:00',
          'website': 'https://example.com',
          'phone': '08123456789',
        },
      };

      final cafe = Cafe.fromOverpassJson(json);

      expect(cafe.id, 'node_12345');
      expect(cafe.name, 'Cafe Ganesha');
      expect(cafe.latitude, -8.112);
      expect(cafe.longitude, 115.088);
      expect(cafe.address, 'Jalan Sudirman, Singaraja');
      expect(cafe.category, 'cafe');
      expect(cafe.openingHours, '08:00-22:00');
      expect(cafe.website, 'https://example.com');
      expect(cafe.phone, '08123456789');
    });

    test('berhasil membaca koordinat dari center pada data way', () {
      final json = {
        'type': 'way',
        'id': 67890,
        'center': {'lat': -8.115, 'lon': 115.090},
        'tags': {'name': 'Coffee House', 'shop': 'coffee'},
      };

      final cafe = Cafe.fromOverpassJson(json);

      expect(cafe.id, 'way_67890');
      expect(cafe.name, 'Coffee House');
      expect(cafe.latitude, -8.115);
      expect(cafe.longitude, 115.090);
      expect(cafe.category, 'coffee');
      expect(cafe.address, 'Alamat tidak tersedia');
    });

    test('menggunakan nilai default jika informasi tidak tersedia', () {
      final json = {
        'type': 'node',
        'id': 111,
        'lat': -8.100,
        'lon': 115.100,
        'tags': <String, dynamic>{},
      };

      final cafe = Cafe.fromOverpassJson(json);

      expect(cafe.name, 'Cafe tanpa nama');
      expect(cafe.address, 'Alamat tidak tersedia');
      expect(cafe.category, 'cafe');
      expect(cafe.openingHours, isNull);
      expect(cafe.website, isNull);
      expect(cafe.phone, isNull);
    });
  });
}
