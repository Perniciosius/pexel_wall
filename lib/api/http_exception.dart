class HTTPException implements Exception {
  final int code;
  final String message;

  HTTPException({required this.code, required this.message});

  @override
  String toString() => "HTTPException {code: $code, message: $message}";
}
