import '../../domain/locations/location_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_location_use_case.g.dart';

@riverpod
Future<Location> getLocationUseCase(GetLocationUseCaseRef ref) async {
  return await ref.read(locationRepositoryProvider).get();
}