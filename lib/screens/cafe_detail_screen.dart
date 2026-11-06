
// Nama  : Gena Anggarani
// NIM   : 2415051038
// Proyek: CafeHunt

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cafe.dart';
import '../models/wishlist.dart';
import '../providers/wishlist_provider.dart';

class CafeDetailScreen extends StatefulWidget {
  final Cafe cafe;

  const CafeDetailScreen({
    super.key,
    required this.cafe,
  });

  @override
  State<CafeDetailScreen> createState() =>
      _CafeDetailScreenState();
}

class _CafeDetailScreenState extends State<CafeDetailScreen> {
  bool _isSaving = false;

  Future<void> _saveToWishlist() async {
    if (_isSaving) return;

    final cafe = widget.cafe;
    final provider = context.read<WishlistProvider>();

    setState(() {
      _isSaving = true;
    });

    try {
      // Memuat wishlist terlebih dahulu jika belum tersedia.
      if (provider.wishlists.isEmpty &&
          !provider.isLoading) {
        await provider.loadWishlists();
      }

      if (!mounted) return;

      // Membuat ID berdasarkan ID cafe dari REST API.
      final cafeId = cafe.id.toString();

      // Memeriksa apakah cafe sudah pernah disimpan.
      final alreadySaved = provider.wishlists.any(
        (item) => item.cafeId == cafeId,
      );

      if (alreadySaved) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Cafe ini sudah ada di Wishlist kamu.',
            ),
          ),
        );
        return;
      }

      final wishlist = Wishlist(
        cafeId: cafeId,
        cafeName: cafe.name,
        address: cafe.address,
        latitude: cafe.latitude,
        longitude: cafe.longitude,
        createdAt: DateTime.now(),
      );

      final success = await provider.addWishlist(wishlist);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? '${cafe.name} berhasil ditambahkan ke Wishlist.'
                : provider.errorMessage ??
                    'Gagal menambahkan cafe ke Wishlist.',
          ),
          backgroundColor:
              success ? const Color(0xFF6F4E37) : Colors.red,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cafe = widget.cafe;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      appBar: AppBar(
        title: const Text('Detail Cafe'),
        backgroundColor: const Color(0xFFFAF8F5),
        foregroundColor: const Color(0xFF302820),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ilustrasi cafe
            Container(
              height: 190,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE8B86D),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.local_cafe_rounded,
                size: 85,
                color: Color(0xFF6F4E37),
              ),
            ),

            const SizedBox(height: 22),

            // Nama cafe
            Text(
              cafe.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF302820),
              ),
            ),

            const SizedBox(height: 8),

            // Kategori cafe
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFE8B86D)
                    .withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                cafe.category,
                style: const TextStyle(
                  color: Color(0xFF6F4E37),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Informasi Cafe',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF302820),
              ),
            ),

            const SizedBox(height: 15),

            _buildInfo(
              Icons.location_on_outlined,
              'Alamat',
              cafe.address,
            ),

            _buildInfo(
              Icons.access_time,
              'Jam Operasional',
              cafe.openingHours ??
                  'Informasi belum tersedia',
            ),

            _buildInfo(
              Icons.phone_outlined,
              'Nomor Telepon',
              cafe.phone ??
                  'Informasi belum tersedia',
            ),

            _buildInfo(
              Icons.language,
              'Website',
              cafe.website ??
                  'Informasi belum tersedia',
            ),

            _buildInfo(
              Icons.map_outlined,
              'Koordinat Lokasi',
              '${cafe.latitude}, ${cafe.longitude}',
            ),

            const SizedBox(height: 12),

            // Tombol menyimpan cafe ke Wishlist
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed:
                    _isSaving ? null : _saveToWishlist,
                icon: _isSaving
                    ? const SizedBox(
                        width: 19,
                        height: 19,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.favorite_rounded,
                      ),
                label: Text(
                  _isSaving
                      ? 'Menyimpan...'
                      : 'Simpan ke Wishlist',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6F4E37),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      const Color(0xFF9A8472),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF6F4E37),
            size: 23,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF756B61),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
