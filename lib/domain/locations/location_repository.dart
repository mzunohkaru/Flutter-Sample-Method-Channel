import '../../model/location.dart';

export '../../model/location.dart';

abstract class LocationRepository {
  Future<Location> get();
  Stream<Location> watch();
}
