import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'cupertino/counters_page.dart';
import 'material/counters_page.dart';

class CountersPage extends StatelessWidget {
  const CountersPage({super.key});

  static bool get _isApple =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  @override
  Widget build(BuildContext context) {
    return _isApple
        ? const CountersPageCupertino()
        : const CountersPageMaterial();
  }
}
