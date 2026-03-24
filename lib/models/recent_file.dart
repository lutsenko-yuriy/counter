/// A recently opened or saved counter file.
///
/// Pure model — no serialization logic. JSON mapping lives in
/// [RecentFilesStorage].
class RecentFile {
  final String path;
  final String name;
  final DateTime lastOpened;

  RecentFile({
    required this.path,
    required this.name,
    required this.lastOpened,
  });
}
