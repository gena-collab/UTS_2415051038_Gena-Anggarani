
import 'package:flutter/material.dart';

import '../models/wishlist.dart';
import '../repositories/wishlist_repository.dart';

class WishlistProvider extends ChangeNotifier {
  final WishlistRepository _repository;

  WishlistProvider(this._repository);

  List<Wishlist> _wishlists = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Wishlist> get wishlists => _wishlists;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadWishlists() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _wishlists = await _repository.getWishlists();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addWishlist(Wishlist wishlist) async {
    try {
      _errorMessage = null;
      final result = await _repository.createWishlist(wishlist);
      _wishlists.insert(0, result);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateWishlist(Wishlist wishlist) async {
    try {
      _errorMessage = null;
      final result = await _repository.editWishlist(wishlist);

      final index = _wishlists.indexWhere(
        (item) => item.id == result.id,
      );

      if (index != -1) {
        _wishlists[index] = result;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteWishlist(String id) async {
    try {
      _errorMessage = null;
      await _repository.removeWishlist(id);

      _wishlists.removeWhere((item) => item.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
