/// Stub implementation — should never be called directly.
Future<void> writeFileBytes(String path, List<int> bytes) {
  throw UnsupportedError('Cannot write files without dart:io or dart:html');
}

/// Stub implementation — should never be called directly.
Future<String> readFileString(String path) {
  throw UnsupportedError('Cannot read files without dart:io or dart:html');
}
