import '../models/models.dart';

/// Serializes a [CounterList] to a JSON-compatible map.
Map<String, dynamic> counterListToJson(CounterList counters) {
  return {
    'counters': counters.counters
        .map((c) => {'id': c.id, 'name': c.name, 'value': c.value})
        .toList(),
  };
}

/// Deserializes a JSON map into a [CounterList].
///
/// The factory's next ID is set to `max(counter.ids) + 1` so that
/// newly created counters receive unique IDs.
CounterList counterListFromJson(Map<String, dynamic> data) {
  final counters = (data['counters'] as List)
      .map((e) => e as Map<String, dynamic>)
      .map((e) => Counter(id: e['id'] as int, value: e['value'] as int)
        ..rename(e['name'] as String))
      .toList();
  final nextId = counters.isEmpty
      ? 1
      : counters.map((c) => c.id).reduce((a, b) => a > b ? a : b) + 1;
  return CounterList.restore(CounterFactory(initialNextId: nextId), counters);
}
