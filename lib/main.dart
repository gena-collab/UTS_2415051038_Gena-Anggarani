
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'providers/cafe_provider.dart';
import 'providers/wishlist_provider.dart';
import 'repositories/cafe_repository.dart';
import 'repositories/wishlist_repository.dart';
import 'screens/home_screen.dart';
import 'services/overpass_service.dart';
import 'services/wishlist_service.dart';
import 'utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (SupabaseConfig.url.isEmpty ||
      SupabaseConfig.anonKey.isEmpty) {
    throw Exception(
      'Supabase URL atau Publishable Key belum diatur.',
    );
  }

  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.anonKey,
  );

  final supabaseClient = Supabase.instance.client;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CafeProvider(
            CafeRepository(OverpassService()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => WishlistProvider(
            WishlistRepository(
              WishlistService(supabaseClient),
            ),
          ),
        ),
      ],
      child: const CafeHuntApp(),
    ),
  );
}

class CafeHuntApp extends StatelessWidget {
  const CafeHuntApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CafeHunt',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
