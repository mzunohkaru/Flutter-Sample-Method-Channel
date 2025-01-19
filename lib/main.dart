import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'domain/locations/gps_location_repository.dart';
import 'domain/locations/location_repository_provider.dart';
import 'ui/home_page.dart';

void main() {
  runApp(
    ProviderScope(
      overrides: [
        // locationRepositoryProvider.overrideWithValue(MockLocationRepository()),
        locationRepositoryProvider.overrideWithValue(GpsLocationRepository()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Native Collaboration Sample',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
