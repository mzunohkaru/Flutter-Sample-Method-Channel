import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/locations/location_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'watch_location_use_case.g.dart';

@riverpod
Stream<Location> watchLocationUseCase(Ref ref) {
  return ref.read(locationRepositoryProvider).watch();
}