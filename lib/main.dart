// Nama  : Gena Anggarani
// NIM   : 2415051038
// Proyek: CafeHunt

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cafe_provider.dart';
import 'repositories/cafe_repository.dart';
import 'screens/home_screen.dart';
import 'services/overpass_service.dart';
import 'utils/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CafeProvider(
            CafeRepository(OverpassService()),
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