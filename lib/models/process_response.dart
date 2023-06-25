class ProcessResponse<T> {
  bool success;
  String message;
  T? object;


ProcessResponse({
    required this.message,
    this.success = false,
    this.object,
  });
}
