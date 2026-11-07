
// Nama  : Gena Anggarani
// NIM   : 2415051038
// Proyek: CafeHunt

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cafe.dart';
import '../providers/cafe_provider.dart';
import '../widgets/category_chip.dart';
import '../widgets/cafe_card.dart';
import '../widgets/empty_state.dart';

import 'cafe_detail_screen.dart';
import 'profile_screen.dart';
import 'wishlist_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const double latitude = -8.112;
  static const double longitude = 115.088;

  static const List<String> categories = [
    'Semua',
    'Coffee Shop',
    'Cafe',
    'Bakery',
    'Ruang Kerja',
  ];

  String selectedCategory = 'Semua';
  String searchQuery = '';

  final TextEditingController searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<CafeProvider>().loadCafes(
            latitude: latitude,
            longitude: longitude,
          );
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Filter cafe berdasarkan pencarian dan kategori.
  List<Cafe> filterCafes(List<Cafe> cafes) {
    return cafes.where((cafe) {
      final query = searchQuery.toLowerCase();

      final matchesSearch =
          cafe.name.toLowerCase().contains(query) ||
          cafe.address.toLowerCase().contains(query);

      final category = cafe.category.toLowerCase();

      bool matchesCategory;

      switch (selectedCategory) {
        case 'Coffee Shop':
          matchesCategory = category == 'coffee_shop';
          break;
        case 'Cafe':
          matchesCategory = category == 'cafe';
          break;
        case 'Bakery':
          matchesCategory = category == 'bakery';
          break;
        case 'Ruang Kerja':
          matchesCategory = category == 'coworking_space';
          break;
        default:
          matchesCategory = true;
      }

      return matchesSearch && matchesCategory;
    }).toList();
  }

  // Mengubah nama kategori agar mudah dibaca.
  String categoryLabel(String category) {
    switch (category.toLowerCase()) {
      case 'coffee_shop':
        return 'Coffee Shop';
      case 'cafe':
        return 'Cafe';
      case 'bakery':
        return 'Bakery';
      case 'coworking_space':
        return 'Ruang Kerja';
      default:
        return category;
    }
  }

  // Menentukan ikon berdasarkan kategori cafe.
  IconData categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'bakery':
        return Icons.bakery_dining_rounded;
      case 'coworking_space':
        return Icons.laptop_mac_rounded;
      default:
        return Icons.local_cafe_rounded;
    }
  }

  // Membuka halaman detail cafe.
  void openCafeDetail(Cafe cafe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CafeDetailScreen(cafe: cafe),
      ),
    );
  }

  // Membuka halaman profil.
  void openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ),
    );
  }

  // Membuka halaman wishlist.
  void openWishlist() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WishlistScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header aplikasi.
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFE4D8),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.local_cafe_rounded,
                      color: Color(0xFF6F4E37),
                      size: 27,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CafeHunt',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF302820),
                          ),
                        ),
                        Text(
                          'Temukan tempat favoritmu',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Notifikasi',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Fitur notifikasi segera hadir.',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      color: Color(0xFF6F4E37),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Profile',
                    onPressed: openProfile,
                    icon: const Icon(
                      Icons.account_circle_outlined,
                      color: Color(0xFF6F4E37),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                'Halo, Cafe Hunters!',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF302820),
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Mau nongkrong di mana hari ini?',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 22),

              // Pencarian cafe.
              TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Cari nama atau lokasi cafe...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () {
                      searchController.clear();
                      setState(() {
                        searchQuery = '';
                      });
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Kategori',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF302820),
                ),
              ),

              const SizedBox(height: 14),

              // Filter kategori menggunakan reusable widget.
              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected =
                        selectedCategory == category;

                    return CategoryChip(
                      label: category,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),

              // Banner Wishlist.
              Material(
                color: const Color(0xFF6F4E37),
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: openWishlist,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Simpan cafe favoritmu!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 7),
                              Text(
                                'Buat daftar tempat yang ingin kamu kunjungi.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Text(
                                    'Lihat Wishlist',
                                    style: TextStyle(
                                      color: Color(0xFFE8B86D),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Color(0xFFE8B86D),
                                    size: 16,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(
                          Icons.favorite_rounded,
                          color: Color(0xFFE8B86D),
                          size: 48,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Daftar cafe.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Jelajahi Cafe',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF302820),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      context.read<CafeProvider>().loadCafes(
                            latitude: latitude,
                            longitude: longitude,
                          );
                    },
                    icon: const Icon(
                      Icons.refresh,
                      size: 16,
                    ),
                    label: const Text('Muat ulang'),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Menampilkan data dari CafeProvider.
              Consumer<CafeProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading &&
                      provider.cafes.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(30),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF6F4E37),
                        ),
                      ),
                    );
                  }

                  // Tampilan ketika API mengalami kesalahan.
                  if (provider.errorMessage != null &&
                      provider.cafes.isEmpty) {
                    return EmptyState(
                      icon: Icons.wifi_off_rounded,
                      title: 'Gagal memuat data cafe',
                      message:
                          'Periksa koneksi internet lalu coba lagi.',
                      actionLabel: 'Coba Lagi',
                      onAction: () {
                        provider.loadCafes(
                          latitude: latitude,
                          longitude: longitude,
                        );
                      },
                    );
                  }

                  final filteredCafes =
                      filterCafes(provider.cafes);

                  // Tampilan ketika cafe tidak ditemukan.
                  if (filteredCafes.isEmpty) {
                    return const EmptyState(
                      icon: Icons.coffee_outlined,
                      title: 'Cafe belum ditemukan',
                      message:
                          'Coba kata kunci atau kategori lainnya.',
                    );
                  }

                  // Menampilkan daftar cafe dengan CafeCard.
                  return Column(
                    children: filteredCafes.map((cafe) {
                      return CafeCard(
                        cafe: cafe,
                        categoryLabel:
                            categoryLabel(cafe.category),
                        categoryIcon:
                            categoryIcon(cafe.category),
                        onTap: () => openCafeDetail(cafe),
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
