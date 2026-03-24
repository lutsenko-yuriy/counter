import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:counter/main.dart';

void main() {
  /// Pre-seeds SharedPreferences with a counter list and file info
  /// so the app starts in "file open" mode (not empty state).
  void setUpWithCounter() {
    SharedPreferences.setMockInitialValues({
      'counters': jsonEncode({
        'counters': [
          {'id': 1, 'name': 'Counter 1', 'value': 0}
        ],
      }),
    });
  }

  setUp(setUpWithCounter);

  testWidgets('Counter increments and decrements', (tester) async {
    await tester.pumpWidget(const CountersApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Increment'));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.byTooltip('Decrement'));
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('Decrement does not go below zero', (tester) async {
    await tester.pumpWidget(const CountersApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Decrement'));
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('Rename counter via dialog', (tester) async {
    await tester.pumpWidget(const CountersApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Counter 1'));
    await tester.pumpAndSettle();

    expect(find.text('Rename Counter'), findsOneWidget);

    final textField = find.byKey(const Key('rename-field'));
    await tester.enterText(textField, 'My Counter');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('My Counter'), findsOneWidget);
    expect(find.text('Counter 1'), findsNothing);
  });
}
