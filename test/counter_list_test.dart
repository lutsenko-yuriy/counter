import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:counter/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App starts with empty state when no file is open',
      (tester) async {
    await tester.pumpWidget(const CountersApp());
    await tester.pumpAndSettle();

    // Should show welcome/empty state
    expect(find.text('Welcome to Counters'), findsOneWidget);
    expect(find.text('Create New File'), findsOneWidget);
    expect(find.text('Open from File'), findsOneWidget);
  });
}
