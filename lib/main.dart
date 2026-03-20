import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'models/models.dart';
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
    final counters = CounterList(CounterFactory());
    if (_isApple) {
      return CupertinoApp(
        title: 'Multi Counter',
        home: CountersPage(title: 'Counters', counters: counters),
      );
    }
    return MaterialApp(
      title: 'Multi Counter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: CountersPage(title: 'Counters', counters: counters),
    );
  }
}
