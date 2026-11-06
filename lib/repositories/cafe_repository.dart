import '../models/cafe.dart';
import '../services/overpass_service.dart';

class CafeRepository {
  final OverpassService _overpassService;

  CafeRepository(this._overpassService);

  Future<List<Cafe>> getCafes({
    required double latitude,
    required double longitude,
  }) {
    return _overpassService.fetchCafes(
      latitude: latitude,
      longitude: longitude,
    );
  }
}