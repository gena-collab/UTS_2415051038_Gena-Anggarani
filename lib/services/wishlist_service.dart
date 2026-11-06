
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/wishlist.dart';

class WishlistService {
  final SupabaseClient _client;

  WishlistService(this._client);

  // READ: Mengambil seluruh wishlist
  Future<List<Wishlist>> fetchWishlists() async {
    final response = await _client
        .from('wishlists')
        .select()
        .order('created_at', ascending: false);

    return (response as List)
        .map(
          (item) => Wishlist.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  // CREATE: Menambahkan wishlist
  Future<Wishlist> addWishlist(Wishlist wishlist) async {
    final response = await _client
        .from('wishlists')
        .insert(wishlist.toJson())
        .select()
        .single();

    return Wishlist.fromJson(response);
  }

  // UPDATE: Mengubah wishlist
  Future<Wishlist> updateWishlist(Wishlist wishlist) async {
    if (wishlist.id == null) {
      throw Exception('ID wishlist tidak ditemukan.');
    }

    final response = await _client
        .from('wishlists')
        .update(wishlist.toJson())
        .eq('id', wishlist.id!)
        .select()
        .single();

    return Wishlist.fromJson(response);
  }

  // DELETE: Menghapus wishlist
  Future<void> deleteWishlist(String id) async {
    await _client
        .from('wishlists')
        .delete()
        .eq('id', id);
  }
}
