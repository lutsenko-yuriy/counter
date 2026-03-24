import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:counter/models/recent_file.dart';
import 'package:counter/state/recent_files_notifier.dart';
import 'package:counter/storage/recent_files_storage.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('RecentFile', () {
    test('creates with path, name, and lastOpened', () {
      final now = DateTime(2026, 3, 22, 12, 0);
      final file = RecentFile(
        path: '/tmp/counters.json',
        name: 'counters.json',
        lastOpened: now,
      );

      expect(file.path, '/tmp/counters.json');
      expect(file.name, 'counters.json');
      expect(file.lastOpened, now);
    });
  });

  group('RecentFilesNotifier', () {
    test('starts empty', () async {
      final notifier = RecentFilesNotifier(RecentFilesStorage());
      await Future<void>.delayed(Duration.zero);

      expect(notifier.files, isEmpty);
    });

    test('adding a file appears in list', () async {
      final notifier = RecentFilesNotifier(RecentFilesStorage());
      await Future<void>.delayed(Duration.zero);

      notifier.addRecent('/tmp/a.json', 'a.json');
      await Future<void>.delayed(Duration.zero);

      expect(notifier.files.length, 1);
      expect(notifier.files.first.name, 'a.json');
      expect(notifier.files.first.path, '/tmp/a.json');
    });

    test('adding a duplicate path moves it to the front', () async {
      final notifier = RecentFilesNotifier(RecentFilesStorage());
      await Future<void>.delayed(Duration.zero);

      notifier.addRecent('/tmp/a.json', 'a.json');
      await Future<void>.delayed(Duration.zero);
      notifier.addRecent('/tmp/b.json', 'b.json');
      await Future<void>.delayed(Duration.zero);
      notifier.addRecent('/tmp/a.json', 'a.json');
      await Future<void>.delayed(Duration.zero);

      expect(notifier.files.length, 2);
      expect(notifier.files.first.path, '/tmp/a.json');
      expect(notifier.files.last.path, '/tmp/b.json');
    });

    test('list caps at 10 entries', () async {
      final notifier = RecentFilesNotifier(RecentFilesStorage());
      await Future<void>.delayed(Duration.zero);

      for (var i = 0; i < 15; i++) {
        notifier.addRecent('/tmp/$i.json', '$i.json');
        await Future<void>.delayed(Duration.zero);
      }

      expect(notifier.files.length, 10);
      // Most recent should be first
      expect(notifier.files.first.name, '14.json');
      // Oldest retained should be last
      expect(notifier.files.last.name, '5.json');
    });

    test('removing a file works', () async {
      final notifier = RecentFilesNotifier(RecentFilesStorage());
      await Future<void>.delayed(Duration.zero);

      notifier.addRecent('/tmp/a.json', 'a.json');
      notifier.addRecent('/tmp/b.json', 'b.json');
      await Future<void>.delayed(Duration.zero);

      notifier.removeRecent('/tmp/a.json');
      await Future<void>.delayed(Duration.zero);

      expect(notifier.files.length, 1);
      expect(notifier.files.first.name, 'b.json');
    });

    test('clearing removes all files', () async {
      final notifier = RecentFilesNotifier(RecentFilesStorage());
      await Future<void>.delayed(Duration.zero);

      notifier.addRecent('/tmp/a.json', 'a.json');
      notifier.addRecent('/tmp/b.json', 'b.json');
      await Future<void>.delayed(Duration.zero);

      notifier.clearRecent();
      await Future<void>.delayed(Duration.zero);

      expect(notifier.files, isEmpty);
    });

    test('persists and restores across instances', () async {
      final storage = RecentFilesStorage();
      final notifier1 = RecentFilesNotifier(storage);
      await Future<void>.delayed(Duration.zero);

      notifier1.addRecent('/tmp/a.json', 'a.json');
      notifier1.addRecent('/tmp/b.json', 'b.json');
      await Future<void>.delayed(Duration.zero);

      // Create new notifier with same storage — should restore
      final notifier2 = RecentFilesNotifier(storage);
      await Future<void>.delayed(Duration.zero);

      expect(notifier2.files.length, 2);
      expect(notifier2.files.first.name, 'b.json');
      expect(notifier2.files.last.name, 'a.json');
    });

    test('notifies listeners on add', () async {
      final notifier = RecentFilesNotifier(RecentFilesStorage());
      await Future<void>.delayed(Duration.zero);

      var notified = false;
      notifier.addListener(() => notified = true);

      notifier.addRecent('/tmp/a.json', 'a.json');
      expect(notified, true);
    });
  });
}
