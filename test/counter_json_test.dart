import 'package:flutter_test/flutter_test.dart';

import 'package:counter/models/models.dart';
import 'package:counter/storage/counter_json.dart';

void main() {
  group('counterListToJson', () {
    test('serializes a counter list to the expected JSON structure', () {
      final factory = CounterFactory();
      final list = CounterList(factory); // starts with Counter 1
      list.add(); // Counter 2
      list[1].increment();
      list[1].increment();
      list[2].rename('My Counter');

      final json = counterListToJson(list);

      expect(json, {
        'counters': [
          {'id': 1, 'name': 'Counter 1', 'value': 2},
          {'id': 2, 'name': 'My Counter', 'value': 0},
        ],
      });
    });

    test('serializes an empty counter list', () {
      final factory = CounterFactory();
      final list = CounterList(factory);
      list.remove(1);

      final json = counterListToJson(list);

      expect(json, {'counters': <Map<String, dynamic>>[]});
    });
  });

  group('counterListFromJson', () {
    test('deserializes valid JSON into a CounterList', () {
      final json = {
        'counters': [
          {'id': 3, 'name': 'Alpha', 'value': 5},
          {'id': 7, 'name': 'Beta', 'value': 0},
        ],
      };

      final list = counterListFromJson(json);

      expect(list.counters.length, 2);
      expect(list[3].name, 'Alpha');
      expect(list[3].value, 5);
      expect(list[7].name, 'Beta');
      expect(list[7].value, 0);
    });

    test('deserializes empty counters list', () {
      final json = {'counters': <Map<String, dynamic>>[]};

      final list = counterListFromJson(json);

      expect(list.isEmpty, true);
    });

    test('factory nextId is max(id) + 1 after deserialization', () {
      final json = {
        'counters': [
          {'id': 5, 'name': 'Counter 5', 'value': 0},
          {'id': 2, 'name': 'Counter 2', 'value': 0},
        ],
      };

      final list = counterListFromJson(json);
      list.add(); // should get id 6

      expect(list.counters.last.id, 6);
      expect(list.counters.last.name, 'Counter 6');
    });

    test('round-trip: serialize then deserialize preserves state', () {
      final factory = CounterFactory();
      final original = CounterList(factory);
      original.add();
      original[1].increment();
      original[1].increment();
      original[1].increment();
      original[2].rename('Renamed');

      final json = counterListToJson(original);
      final restored = counterListFromJson(json);

      expect(restored.counters.length, original.counters.length);
      for (var i = 0; i < original.counters.length; i++) {
        expect(restored.counters[i].id, original.counters[i].id);
        expect(restored.counters[i].name, original.counters[i].name);
        expect(restored.counters[i].value, original.counters[i].value);
      }
    });
  });
}
