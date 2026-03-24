import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../models/models.dart';
import 'counter_json.dart';
import 'file_writer_stub.dart'
    if (dart.library.io) 'file_writer_native.dart'
    if (dart.library.html) 'file_writer_web.dart' as file_writer;

/// Handles reading and writing counter data to/from JSON files.
///
/// Uses [file_picker] for cross-platform file dialogs. On web, file paths
/// are not available — files are read from bytes and saved via download.
class CounterFileStorage {
  /// Serializes a [CounterList] to a JSON string.
  String serialize(CounterList counters) {
    return const JsonEncoder.withIndent('  ')
        .convert(counterListToJson(counters));
  }

  /// Deserializes a JSON string into a [CounterList].
  CounterList deserialize(String json) {
    final data = jsonDecode(json) as Map<String, dynamic>;
    return counterListFromJson(data);
  }

  /// Opens a file picker and returns the loaded [CounterList] and file info,
  /// or `null` if the user cancelled.
  Future<({CounterList counters, String name, String? path})?>
      pickAndLoad() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return null;

    final file = result.files.first;
    final bytes = file.bytes;
    if (bytes == null) return null;

    final json = utf8.decode(bytes);
    final counters = deserialize(json);
    return (counters: counters, name: file.name, path: file.path);
  }

  /// Opens a save dialog and writes the counters to the chosen file.
  /// Returns the file name and path, or `null` if the user cancelled.
  Future<({String name, String? path})?> pickAndSave(
      CounterList counters) async {
    final json = serialize(counters);
    final bytes = utf8.encode(json);

    final result = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Counters',
      fileName: 'counters.json',
      type: FileType.custom,
      allowedExtensions: ['json'],
      bytes: Uint8List.fromList(bytes),
    );

    if (result == null) return null;

    // On native, file_picker returns a path but doesn't write the file.
    // On web, the bytes parameter triggers a download automatically.
    if (!kIsWeb) {
      await file_writer.writeFileBytes(result, bytes);
    }

    final name = result.split('/').last.split('\\').last;
    return (name: name, path: kIsWeb ? null : result);
  }

  /// Loads counters from a known file path.
  /// Only works on native platforms; throws on web.
  Future<CounterList> loadFromPath(String path) async {
    final json = await file_writer.readFileString(path);
    return deserialize(json);
  }

  /// Saves counters to a known file path (for auto-save).
  /// Only works on native platforms; returns false on web.
  Future<bool> saveToPath(String path, CounterList counters) async {
    if (kIsWeb) return false;
    final json = serialize(counters);
    final bytes = utf8.encode(json);
    try {
      await file_writer.writeFileBytes(path, bytes);
      return true;
    } catch (_) {
      return false;
    }
  }
}
