import 'dart:io';

/// Writes bytes to a file at the given [path] on native platforms.
Future<void> writeFileBytes(String path, List<int> bytes) async {
  await File(path).writeAsBytes(bytes);
}

/// Reads a file at the given [path] as a UTF-8 string on native platforms.
Future<String> readFileString(String path) async {
  return await File(path).readAsString();
}
