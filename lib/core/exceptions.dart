class DecryptionException implements Exception {
  final String message;
  final dynamic originalError;

  DecryptionException(this.message, [this.originalError]);

  @override
  String toString() => "DecryptionException: $message ${originalError != null ? '($originalError)' : ''}";
}
