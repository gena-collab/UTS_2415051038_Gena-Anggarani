import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:cafehunt/main.dart';
import 'package:cafehunt/models/cafe.dart';
import 'package:cafehunt/models/wishlist.dart';
import 'package:cafehunt/providers/cafe_provider.dart';
import 'package:cafehunt/providers/wishlist_provider.dart';
import 'package:cafehunt/repositories/cafe_repository.dart';
import 'package:cafehunt/repositories/wishlist_repository.dart';
import 'package:cafehunt/screens/home_screen.dart';
import 'package:cafehunt/services/overpass_service.dart';

class FakeCafeRepository extends CafeRepository {
  FakeCafeRepository() : super(OverpassService());

  @override
  Future<List<Cafe>> getCafes({
    required double latitude,
    required double longitude,
  }) async {
    return [];
  }
}

class FakeWishlistRepository implements WishlistRepository {
  @override
  Future<List<Wishlist>> getWishlists() async {
    return [];
  }

  @override
  Future<Wishlist> createWishlist(Wishlist wishlist) async {
    return wishlist;
  }

  @override
  Future<Wishlist> editWishlist(Wishlist wishlist) async {
    return wishlist;
  }

  @override
  Future<void> removeWishlist(String id) async {}
}

void main() {
  testWidgets('CafeHunt menampilkan halaman Home', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => CafeProvider(FakeCafeRepository()),
          ),
          ChangeNotifierProvider(
            create: (_) => WishlistProvider(FakeWishlistRepository()),
          ),
        ],
        child: const CafeHuntApp(),
      ),
    );

    await tester.pump();
    await tester.pump();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(Scaffold), findsWidgets);
  });
}
