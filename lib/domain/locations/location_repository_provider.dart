import './location_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

export 'location.dart';

@riverpod
final locationRepositoryProvider =
Provider<LocationRepository>((_) => throw UnimplementedError());
