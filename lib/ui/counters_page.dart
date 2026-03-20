import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../models/models.dart';
import 'cupertino/counters_page.dart';
import 'material/counters_page.dart';

class CountersPage extends StatelessWidget {
  const CountersPage({super.key, required this.title, required this.counters});

  final String title;
  final CounterList counters;

  static bool get _isApple =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  @override
  Widget build(BuildContext context) {
    return _isApple
        ? CountersPageCupertino(title: title, counters: counters)
        : CountersPageMaterial(title: title, counters: counters);
  }
}
