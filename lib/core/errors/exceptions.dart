class DatabaseException implements Exception {
  const DatabaseException(this.message);
  final String message;

  @override
  String toString() => 'DatabaseException: $message';
}

class MediaException implements Exception {
  const MediaException(this.message);
  final String message;

  @override
  String toString() => 'MediaException: $message';
}

class StorageException implements Exception {
  const StorageException(this.message);
  final String message;

  @override
  String toString() => 'StorageException: $message';
}
