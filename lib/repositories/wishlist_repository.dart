
import '../models/wishlist.dart';
import '../services/wishlist_service.dart';

class WishlistRepository {
  final WishlistService _service;

  WishlistRepository(this._service);

  Future<List<Wishlist>> getWishlists() {
    return _service.fetchWishlists();
  }

  Future<Wishlist> createWishlist(Wishlist wishlist) {
    return _service.addWishlist(wishlist);
  }

  Future<Wishlist> editWishlist(Wishlist wishlist) {
    return _service.updateWishlist(wishlist);
  }

  Future<void> removeWishlist(String id) {
    return _service.deleteWishlist(id);
  }
}
