import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:counter/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App renders counter page immediately without splash screen',
      (tester) async {
    await tester.pumpWidget(const CountersApp());
    await tester.pump();

    // The main content should be visible immediately — no splash delay
    expect(find.text('Welcome to Counters'), findsOneWidget);
  });
}
