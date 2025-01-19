import 'dart:async';

import 'package:flutter/services.dart';
import './location_repository.dart';

/// GPSを使った位置情報を取得するための仕組み。
class GpsLocationRepository extends LocationRepository {
  static const platform = MethodChannel('com.example.method_channel_sample');

  /// MethodChannel
  @override
  Future<Location> get() async {
    final String result = await platform.invokeMethod('getLocation');
    final splitted = result.split(',');
    return Location(double.parse(splitted[0]), double.parse(splitted[1]));
  }

  /// EventChannel
  static const eventChannel = EventChannel('com.example.event_channel_sample');
  StreamSubscription<dynamic>? _locationSubscription;
  StreamController<Location>? _locationStreamController;

  @override
  Stream<Location> watch() {
    if (_locationSubscription != null) {
      return _locationStreamController!.stream;
    }
    _locationSubscription = eventChannel.receiveBroadcastStream().listen(
      (event) {
        final splitted = (event as String).split(',');
        final location =
            Location(double.parse(splitted[0]), double.parse(splitted[1]));
        print("更新された位置情報: 緯度 ${location.latitude}, 経度 ${location.longitude}");
        _locationStreamController!.add(location);
      },
      onError: (dynamic error) {
        print('Received error: ${error.message}');
      },
    );
    platform.invokeMethod('watchLocation');

    _locationStreamController = StreamController<Location>();
    return _locationStreamController!.stream;
  }
}
