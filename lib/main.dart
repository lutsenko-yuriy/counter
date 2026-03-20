import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state/counter_list_notifier.dart';
import 'storage/counter_storage.dart';
import 'ui/counters_page.dart';

void main() {
  runApp(const CountersApp());
}

class CountersApp extends StatelessWidget {
  const CountersApp({super.key});

  static bool get _isApple =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CounterListNotifier(CounterStorage()),
      child: _isApple
          ? const CupertinoApp(
              title: 'Multi Counter',
              home: CountersPage(title: 'Counters'),
            )
          : MaterialApp(
              title: 'Multi Counter',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: const CountersPage(title: 'Counters'),
            ),
    );
  }
}
