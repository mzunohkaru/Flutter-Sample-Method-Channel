import 'package:flutter/material.dart';
import 'body/event_channel_body.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ネイティブ連携"),
      ),
      // 1) 位置情報を一度だけ取得します。
      // body: const MethodChannelBody(),
      // 2) 位置情報を常に更新できるようにします。
      body: const EventChannelBody(),
    );
  }
}
