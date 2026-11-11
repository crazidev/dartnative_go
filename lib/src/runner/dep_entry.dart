/// Metadata entry for a pure-Dart dependency package loaded by the client.
class DepEntry {
  final String name;
  final String version;
  final String zipUrl;
  final String contentHash;
  final int byteSize;

  const DepEntry({
    required this.name,
    required this.version,
    required this.zipUrl,
    required this.contentHash,
    required this.byteSize,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'version': version,
    'zipUrl': zipUrl,
    'contentHash': contentHash,
    'byteSize': byteSize,
  };

  factory DepEntry.fromJson(Map<String, dynamic> json) => DepEntry(
    name: json['name'] as String,
    version: json['version'] as String? ?? '1.0.0',
    zipUrl: json['zipUrl'] as String,
    contentHash: json['contentHash'] as String,
    byteSize: json['byteSize'] as int? ?? 0,
  );
}
