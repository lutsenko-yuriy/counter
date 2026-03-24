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

      expect(notifier.counters!.counters.length, 1);
      expect(notifier.counters!.counters.first.name, 'Counter 1');

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
    });

    test('clearCurrentFile resets file info', () async {
      final notifier = CounterListNotifier(CounterStorage());
      await Future<void>.delayed(Duration.zero);

      notifier.setCurrentFile('test.json', '/tmp/test.json');
      notifier.clearCurrentFile();

      expect(notifier.currentFileName, isNull);
      expect(notifier.currentFilePath, isNull);
    });
  });

  group('auto-save timestamp', () {
    test('lastSavedAt is null initially', () async {
      final notifier = CounterListNotifier(CounterStorage());
      await Future<void>.delayed(Duration.zero);

      expect(notifier.lastSavedAt, isNull);
    });

    test('markSaved updates the timestamp', () async {
      final notifier = CounterListNotifier(CounterStorage());
      await Future<void>.delayed(Duration.zero);

      final before = DateTime.now();
      notifier.markSaved();
      final after = DateTime.now();

      expect(notifier.lastSavedAt, isNotNull);
      expect(notifier.lastSavedAt!.isAfter(before.subtract(
          const Duration(milliseconds: 1))), true);
      expect(notifier.lastSavedAt!.isBefore(after.add(
          const Duration(milliseconds: 1))), true);
    });
  });
}
