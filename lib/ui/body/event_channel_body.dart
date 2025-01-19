import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../use_cases/watch_location/watch_location_use_case.dart';
import '../components/body.dart';

class EventChannelBody extends ConsumerWidget {
  const EventChannelBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(watchLocationUseCaseProvider);

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
                  ref.invalidate(watchLocationUseCaseProvider);
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
