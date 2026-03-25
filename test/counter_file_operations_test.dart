import 'package:flutter_test/flutter_test.dart';

import 'package:counter/models/models.dart';
import 'package:counter/state/counter_list_notifier.dart';

void main() {
  group('replaceCounters', () {
    test('replaces the current counter list and notifies', () {
      final notifier = CounterListNotifier();

      // Starts empty (no file open)
      expect(notifier.counters.isEmpty, true);

      final factory = CounterFactory(initialNextId: 10);
      final newList = CounterList.restore(factory, [
        Counter(id: 5, value: 42)..rename('Imported'),
        Counter(id: 8, value: 7)..rename('Another'),
      ]);

      var notified = false;
      notifier.addListener(() => notified = true);

      notifier.replaceCounters(newList);

      expect(notified, true);
      expect(notifier.counters.counters.length, 2);
      expect(notifier.counters[5].name, 'Imported');
      expect(notifier.counters[5].value, 42);
      expect(notifier.counters[8].name, 'Another');
    });
  });

  group('current file tracking', () {
    test('starts with no current file', () {
      final notifier = CounterListNotifier();

      expect(notifier.currentFileName, isNull);
      expect(notifier.currentFilePath, isNull);
      expect(notifier.hasNoFile, true);
    });

    test('setCurrentFile updates name and path', () {
      final notifier = CounterListNotifier();

      var notified = false;
      notifier.addListener(() => notified = true);

      notifier.setCurrentFile('my_counters.json', '/tmp/my_counters.json');

      expect(notified, true);
      expect(notifier.currentFileName, 'my_counters.json');
      expect(notifier.currentFilePath, '/tmp/my_counters.json');
      expect(notifier.hasNoFile, false);
    });

    test('displayFileName strips extension', () {
      final notifier = CounterListNotifier();

      expect(notifier.displayFileName, isNull);

      notifier.setCurrentFile('my_counters.json', '/tmp/my_counters.json');
      expect(notifier.displayFileName, 'my_counters');

      notifier.setCurrentFile('data.backup.json', '/tmp/data.backup.json');
      expect(notifier.displayFileName, 'data.backup');

      notifier.setCurrentFile('noext', '/tmp/noext');
      expect(notifier.displayFileName, 'noext');
    });

    test('clearCurrentFile resets file info', () {
      final notifier = CounterListNotifier();

      notifier.setCurrentFile('test.json', '/tmp/test.json');
      notifier.clearCurrentFile();

      expect(notifier.currentFileName, isNull);
      expect(notifier.currentFilePath, isNull);
      expect(notifier.hasNoFile, true);
    });
  });

  group('saving state', () {
    test('isSaving is false initially', () {
      final notifier = CounterListNotifier();
      expect(notifier.isSaving, false);
    });

    test('lastSavedAt is null initially', () {
      final notifier = CounterListNotifier();
      expect(notifier.lastSavedAt, isNull);
    });

    test('markSaved updates the timestamp and clears isSaving', () {
      final notifier = CounterListNotifier();

      final before = DateTime.now();
      notifier.markSaved();
      final after = DateTime.now();

      expect(notifier.lastSavedAt, isNotNull);
      expect(notifier.isSaving, false);
      expect(
          notifier.lastSavedAt!
              .isAfter(before.subtract(const Duration(milliseconds: 1))),
          true);
      expect(
          notifier.lastSavedAt!
              .isBefore(after.add(const Duration(milliseconds: 1))),
          true);
    });
  });

  group('empty initial state', () {
    test('starts with empty counter list when no initial data', () {
      final notifier = CounterListNotifier();

      expect(notifier.counters.isEmpty, true);
      expect(notifier.counters.counters.length, 0);
      expect(notifier.hasNoFile, true);
    });
  });

  group('initial state from file', () {
    test('accepts initial counters and file info', () {
      final factory = CounterFactory(initialNextId: 3);
      final counters = CounterList.restore(factory, [
        Counter(id: 1, value: 5)..rename('Test'),
      ]);

      final notifier = CounterListNotifier(
        initialCounters: counters,
        initialFileName: 'test.json',
        initialFilePath: '/tmp/test.json',
      );

      expect(notifier.counters.counters.length, 1);
      expect(notifier.counters[1].name, 'Test');
      expect(notifier.counters[1].value, 5);
      expect(notifier.currentFileName, 'test.json');
      expect(notifier.currentFilePath, '/tmp/test.json');
      expect(notifier.hasNoFile, false);
      expect(notifier.displayFileName, 'test');
    });

    test('lastSavedAt is set when restored from file with path', () {
      final before = DateTime.now();
      final notifier = CounterListNotifier(
        initialFileName: 'test.json',
        initialFilePath: '/tmp/test.json',
      );
      final after = DateTime.now();

      expect(notifier.lastSavedAt, isNotNull);
      expect(
          notifier.lastSavedAt!
              .isAfter(before.subtract(const Duration(milliseconds: 1))),
          true);
      expect(
          notifier.lastSavedAt!
              .isBefore(after.add(const Duration(milliseconds: 1))),
          true);
    });

    test('lastSavedAt stays null when no file path provided', () {
      final notifier = CounterListNotifier();
      expect(notifier.lastSavedAt, isNull);
    });
  });
}
