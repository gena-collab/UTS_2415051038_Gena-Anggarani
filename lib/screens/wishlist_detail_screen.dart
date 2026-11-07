
import 'package:flutter/material.dart';

import '../models/wishlist.dart';

class WishlistDetailScreen extends StatelessWidget {
  final Wishlist wishlist;

  const WishlistDetailScreen({
    super.key,
    required this.wishlist,
  });

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEFE4D8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF6F4E37),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                SelectableText(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Wishlist',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFE4D8),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.local_cafe_rounded,
                    size: 55,
                    color: Color(0xFF6F4E37),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  wishlist.cafeName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Cafe tersimpan di Wishlist kamu',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Informasi Cafe',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
              Card(
                color: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      _buildInfoItem(
                        icon: Icons.badge_outlined,
                        label: 'ID Cafe',
                        value: wishlist.cafeId,
                      ),
                      _buildInfoItem(
                        icon: Icons.store_outlined,
                        label: 'Nama Cafe',
                        value: wishlist.cafeName,
                      ),
                      _buildInfoItem(
                        icon: Icons.location_on_outlined,
                        label: 'Alamat',
                        value: wishlist.address,
                      ),
                      _buildInfoItem(
                        icon: Icons.map_outlined,
                        label: 'Latitude',
                        value: wishlist.latitude.toString(),
                      ),
                      _buildInfoItem(
                        icon: Icons.explore_outlined,
                        label: 'Longitude',
                        value: wishlist.longitude.toString(),
                      ),
                      _buildInfoItem(
                        icon: Icons.calendar_today_outlined,
                        label: 'Tanggal Disimpan',
                        value: wishlist.createdAt.toLocal().toString(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Kembali ke Wishlist'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF6F4E37),
                    side: const BorderSide(
                      color: Color(0xFF6F4E37),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
