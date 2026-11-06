import 'package:flutter/material.dart';

import '../models/cafe.dart';
import '../repositories/cafe_repository.dart';

class CafeProvider extends ChangeNotifier {
  final CafeRepository _repository;

  CafeProvider(this._repository);

  List<Cafe> _cafes = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Cafe> get cafes => _cafes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadCafes({
    required double latitude,
    required double longitude,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cafes = await _repository.getCafes(
        latitude: latitude,
        longitude: longitude,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}