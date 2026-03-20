import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:counter/main.dart';

void main() {
  testWidgets('App starts with one counter at zero', (tester) async {
    await tester.pumpWidget(const CountersApp());

    expect(find.text('Counter 1'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('Counter increments and decrements', (tester) async {
    await tester.pumpWidget(const CountersApp());

    await tester.tap(find.byTooltip('Increment'));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.byTooltip('Decrement'));
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('Decrement does not go below zero', (tester) async {
    await tester.pumpWidget(const CountersApp());

    await tester.tap(find.byTooltip('Decrement'));
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('Add counter creates a new counter', (tester) async {
    await tester.pumpWidget(const CountersApp());

    await tester.tap(find.byTooltip('Add Counter'));
    await tester.pump();

    expect(find.text('Counter 1'), findsOneWidget);
    expect(find.text('Counter 2'), findsOneWidget);
  });

  testWidgets('Delete counter removes it', (tester) async {
    await tester.pumpWidget(const CountersApp());

    await tester.tap(find.byTooltip('Delete counter'));
    await tester.pump();

    expect(find.text('Counter 1'), findsNothing);
    expect(find.text('No counters yet. Tap + to add one.'), findsOneWidget);
  });

  testWidgets('Rename counter via dialog', (tester) async {
    await tester.pumpWidget(const CountersApp());

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
