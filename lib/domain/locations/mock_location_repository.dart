import 'dart:async';
import 'dart:math';

import './location_repository.dart';

class MockLocationRepository extends LocationRepository {
  @override
  Future<Location> get() async {
    return const Location(35, 135);
  }

  @override
  Stream<Location> watch() {
    final random = Random();
    final controller = StreamController<Location>();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      final random1 = random.nextDouble();
      final random2 = random.nextDouble();
      controller.add(Location(36 + random1, 138 + random2));
    });
    return controller.stream;
  }
}