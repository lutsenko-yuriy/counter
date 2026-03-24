/// On web, file_picker handles downloads via the bytes parameter.
/// No additional file writing is needed.
Future<void> writeFileBytes(String path, List<int> bytes) async {
  // No-op on web — file_picker.saveFile with bytes triggers a download.
}
