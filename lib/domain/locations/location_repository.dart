import 'location.dart';

export 'location.dart';

abstract class LocationRepository {
  Future<Location> get();

  Stream<Location> watch();
}
