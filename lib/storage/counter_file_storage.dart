import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../models/models.dart';
import 'counter_json.dart';
import 'file_writer_stub.dart'
    if (dart.library.io) 'file_writer_native.dart'
    if (dart.library.html) 'file_writer_web.dart' as file_writer;

/// Whether the current platform supports direct filesystem access via paths.
///
/// Only desktop platforms (macOS, Linux, Windows) have unrestricted file I/O.
/// Mobile platforms use sandboxed storage (SAF on Android, app sandbox on iOS)
/// and web has no filesystem access at all.
bool get hasDirectFileAccess =>
    !kIsWeb &&
    defaultTargetPlatform != TargetPlatform.android &&
    defaultTargetPlatform != TargetPlatform.iOS;

/// Handles reading and writing counter data to/from JSON files.
///
/// Uses [file_picker] for cross-platform file dialogs. On web and mobile,
/// file_picker handles writing via its own mechanism (SAF / share sheet).
/// On desktop, we write files directly via dart:io.
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
    // Only return the path on desktop where we can reuse it for auto-save
    return (
      counters: counters,
      name: file.name,
      path: hasDirectFileAccess ? file.path : null,
    );
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

    // On desktop, file_picker returns a path but doesn't write the file.
    // On web and mobile, the bytes parameter / SAF handles writing.
    if (hasDirectFileAccess) {
      await file_writer.writeFileBytes(result, bytes);
    }

    final name = result.split('/').last.split('\\').last;
    return (name: name, path: hasDirectFileAccess ? result : null);
  }

  /// Loads counters from a known file path.
  /// Only works on desktop platforms with direct filesystem access.
  Future<CounterList> loadFromPath(String path) async {
    final json = await file_writer.readFileString(path);
    return deserialize(json);
  }

  /// Saves counters to a known file path (for auto-save).
  /// Only works on desktop platforms; returns false elsewhere.
  Future<bool> saveToPath(String path, CounterList counters) async {
    if (!hasDirectFileAccess) return false;
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
