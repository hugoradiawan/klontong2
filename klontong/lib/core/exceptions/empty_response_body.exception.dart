class EmptyResponseBodyException implements Exception {
  final String message;

  EmptyResponseBodyException(
      [this.message = 'The Response have unexpected empty response body.']);

  @override
  String toString() => 'EmptyResponseBodyException: $message';
}