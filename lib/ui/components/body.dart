import 'package:flutter/material.dart';

import '../../model/location.dart';

class LocationBody extends StatelessWidget {
  const LocationBody({
    super.key,
    required this.location,
  });

  final Location location;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
          "現在緯度: ${location.latitude.toStringAsFixed(2)}, 現在経度: ${location.longitude.toStringAsFixed(2)}"),
    );
  }
}
