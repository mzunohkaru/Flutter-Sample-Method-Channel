import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/locations/location_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_location_use_case.g.dart';

@riverpod
Future<Location> fetchLocationUseCase(Ref ref) async {
  return await ref.read(locationRepositoryProvider).get();
}