import 'dart:io';

/// Writes bytes to a file at the given [path] on native platforms.
Future<void> writeFileBytes(String path, List<int> bytes) async {
  await File(path).writeAsBytes(bytes);
}
