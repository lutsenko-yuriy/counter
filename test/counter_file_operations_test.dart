import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:counter/models/models.dart';
import 'package:counter/state/counter_list_notifier.dart';
import 'package:counter/storage/counter_storage.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('replaceCounters', () {
    test('replaces the current counter list and notifies', () async {
      final notifier = CounterListNotifier(CounterStorage());
      await Future<void>.delayed(Duration.zero);

      // Starts empty (no file open)
      expect(notifier.counters!.isEmpty, true);

      final factory = CounterFactory(initialNextId: 10);
      final newList = CounterList.restore(factory, [
        Counter(id: 5, value: 42)..rename('Imported'),
        Counter(id: 8, value: 7)..rename('Another'),
      ]);

      var notified = false;
      notifier.addListener(() => notified = true);

      notifier.replaceCounters(newList);

      expect(notified, true);
      expect(notifier.counters!.counters.length, 2);
      expect(notifier.counters![5].name, 'Imported');
      expect(notifier.counters![5].value, 42);
      expect(notifier.counters![8].name, 'Another');
    });
  });

  group('current file tracking', () {
    test('starts with no current file', () async {
      final notifier = CounterListNotifier(CounterStorage());
      await Future<void>.delayed(Duration.zero);

      expect(notifier.currentFileName, isNull);
      expect(notifier.currentFilePath, isNull);
      expect(notifier.hasNoFile, true);
    });

    test('setCurrentFile updates name and path', () async {
      final notifier = CounterListNotifier(CounterStorage());
      await Future<void>.delayed(Duration.zero);

      var notified = false;
      notifier.addListener(() => notified = true);

      notifier.setCurrentFile('my_counters.json', '/tmp/my_counters.json');

      expect(notified, true);
      expect(notifier.currentFileName, 'my_counters.json');
      expect(notifier.currentFilePath, '/tmp/my_counters.json');
      expect(notifier.hasNoFile, false);
    });

    test('displayFileName strips extension', () async {
      final notifier = CounterListNotifier(CounterStorage());
      await Future<void>.delayed(Duration.zero);

      expect(notifier.displayFileName, isNull);

      notifier.setCurrentFile('my_counters.json', '/tmp/my_counters.json');
      expect(notifier.displayFileName, 'my_counters');

      notifier.setCurrentFile('data.backup.json', '/tmp/data.backup.json');
      expect(notifier.displayFileName, 'data.backup');

      notifier.setCurrentFile('noext', '/tmp/noext');
      expect(notifier.displayFileName, 'noext');
    });

    test('clearCurrentFile resets file info', () async {
      final notifier = CounterListNotifier(CounterStorage());
      await Future<void>.delayed(Duration.zero);

      notifier.setCurrentFile('test.json', '/tmp/test.json');
      notifier.clearCurrentFile();

      expect(notifier.currentFileName, isNull);
      expect(notifier.currentFilePath, isNull);
      expect(notifier.hasNoFile, true);
    });
  });

  group('saving state', () {
    test('isSaving is false initially', () async {
      final notifier = CounterListNotifier(CounterStorage());
      await Future<void>.delayed(Duration.zero);

      expect(notifier.isSaving, false);
    });

    test('lastSavedAt is null initially', () async {
      final notifier = CounterListNotifier(CounterStorage());
      await Future<void>.delayed(Duration.zero);

      expect(notifier.lastSavedAt, isNull);
    });

    test('markSaved updates the timestamp and clears isSaving', () async {
      final notifier = CounterListNotifier(CounterStorage());
      await Future<void>.delayed(Duration.zero);

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
    test('starts with empty counter list when no persisted data', () async {
      final notifier = CounterListNotifier(CounterStorage());
      await Future<void>.delayed(Duration.zero);

      expect(notifier.counters!.isEmpty, true);
      expect(notifier.counters!.counters.length, 0);
      expect(notifier.hasNoFile, true);
    });
  });
}
