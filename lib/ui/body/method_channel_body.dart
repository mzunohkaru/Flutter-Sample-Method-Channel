import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../use_cases/fetch_location/fetch_location_use_case.dart';
import '../components/body.dart';

class MethodChannelBody extends ConsumerWidget {
  const MethodChannelBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(fetchLocationUseCaseProvider);
    return switch (location) {
      AsyncData(:final value) => LocationBody(
          location: value,
        ),
      AsyncError(:final error) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("読み込みエラー： $error"),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(fetchLocationUseCaseProvider);
                },
                child: Text('再試行'),
              ),
            ],
          ),
        ),
      _ => const Center(
          child: CircularProgressIndicator(),
        ),
    };
  }
}
